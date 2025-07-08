Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47602E0411;
	Tue,  8 Jul 2025 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992641; cv=none; b=G8M/w2lcw6tMMzykplakcMmR7dP6aUkzt3385eZB1WrwZ/LhPabyfRQONFhDgJ2ser3EycHQcUqy4u9o/CTspOiN1u/llXw33d3CrCjJb1J/c9EYtVpnn2yudH8AraJ+6THN0HXBDFlJy3TQ2vpGz+zQVlwBSh0kO0Ir9wSD0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992641; c=relaxed/simple;
	bh=YTdsBrJRTD/u9vbfO5sMVuZT01V5vE+puJB9gfORllA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gajWhzWO3LVJ3gLh7yWTTBbwufFncVNdt92UzZuar5ih22f91WZY+j9czHmt1+Y8IQEa+RCjonal3RNXIr9CrajjvNbe8L5JDINNsYFZifpB6Tv5xJvlVZNf9sSl0OqRZnt/vini14UblojC5G0SlqDX+mpQe0WVKnNq5WZsbNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvimEnHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvimEnHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FA0C4CEED;
	Tue,  8 Jul 2025 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992641;
	bh=YTdsBrJRTD/u9vbfO5sMVuZT01V5vE+puJB9gfORllA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvimEnHpEmANfM/qgpjTcg92Mu57wfkXfTP8YExlqKeHo4cp5zzmkf8l0LkU37Evm
	 ynwVbrZcQ58DPHVt8zKvH00gVxDkkQdjztY1ow962rRzsQXmykx6hLyjcdBCR1WRuj
	 gx7tyWMnCs0l+PfgCkZYcNsmMKJarGCmMcvijplg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 007/232] s390/pci: Do not try re-enabling load/store if device is disabled
Date: Tue,  8 Jul 2025 18:20:03 +0200
Message-ID: <20250708162241.624512184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -105,6 +105,10 @@ static pci_ers_result_t zpci_event_do_er
 	struct zpci_dev *zdev = to_zpci(pdev);
 	int rc;
 
+	/* The underlying device may have been disabled by the event */
+	if (!zdev_enabled(zdev))
+		return PCI_ERS_RESULT_NEED_RESET;
+
 	pr_info("%s: Unblocking device access for examination\n", pci_name(pdev));
 	rc = zpci_reset_load_store_blocked(zdev);
 	if (rc) {


