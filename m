Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9281AB672;
	Tue,  8 Jul 2025 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993324; cv=none; b=lXg+OwGa+izrnSFoJc6ARlF7Z/ddpLJ7ejeCvl7MAaPm7/qsrzy5ltOBmmSFIJ6boZ6QCWcmY0lZiYnaNGxAa4+YnmIMZhv22Ywm9P8BIy5AvGpT/0Rcc4UKHb0Wa7SGc7RfvX1G9tIYDoWAP2K7566o2gY69MMedwgL5Rk4rWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993324; c=relaxed/simple;
	bh=Zoh1cdPDnsnRnqYACXGy8j6NnWb/MgXg6Ps8Ja186tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKy30UwKPuPoi1/cX7ZN3j3ALmzbrEeHB4rd04dMqoTjpOKsfJB1BwuhSLdYUR1FBGZiFZnwUTJ4u+wOgnCyMaELigesl48lBcXia4lcfnNyFfGzBigC9y83C13r7TYaCCSWRCCW2VvW2GA/CsoB+Kj0hCqjeasZxDSixKLzn+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvIqFdTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvIqFdTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF6EC4CEED;
	Tue,  8 Jul 2025 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993324;
	bh=Zoh1cdPDnsnRnqYACXGy8j6NnWb/MgXg6Ps8Ja186tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvIqFdTVcYkBY7nMZC/Fj5anJfwb5RIEtlqJzUhkG+JraOybkACizfzHRwrZwx5tq
	 jQkrCpDSGbrMbDzqbi0GQoK9St+lZx6PgLvLD0uR7TKs4fcPtWe4+UnP+QCS2uFXfV
	 qy5kJxkf8IS6m6XRPCEYphNFJgirzxVnkCD9LX1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.15 007/178] s390/pci: Do not try re-enabling load/store if device is disabled
Date: Tue,  8 Jul 2025 18:20:44 +0200
Message-ID: <20250708162236.747010277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit b97a7972b1f4f81417840b9a2ab0c19722b577d5 upstream.

If a device is disabled unblocking load/store on its own is not useful
as a full re-enable of the function is necessary anyway. Note that SCLP
Write Event Data Action Qualifier 0 (Reset) leaves the device disabled
and triggers this case unless the driver already requests a reset.

Cc: stable@vger.kernel.org
Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -106,6 +106,10 @@ static pci_ers_result_t zpci_event_do_er
 	struct zpci_dev *zdev = to_zpci(pdev);
 	int rc;
 
+	/* The underlying device may have been disabled by the event */
+	if (!zdev_enabled(zdev))
+		return PCI_ERS_RESULT_NEED_RESET;
+
 	pr_info("%s: Unblocking device access for examination\n", pci_name(pdev));
 	rc = zpci_reset_load_store_blocked(zdev);
 	if (rc) {


