Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5B81F1522;
	Mon, 23 Jun 2025 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684466; cv=none; b=fCJuCmiaShupWACNGZwnEJ4XZKXOPcVHLqDMjTZhJss2snLR0XguYefNU2yiF7oTdmD+jlpUxRLbx/YJK2ihN/BMYRq9f8mw+YBrzzkZED12CFUC5mfU2DaRBDEzLtN2thx9sgHcr6JqqkX0/jH8xuSTimWepqouJOT1N3fBhUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684466; c=relaxed/simple;
	bh=U5WYrlJPlkAZnLyFhwzh20EV6jqB44qBGpWaI2giGVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/sk0G2sLzlZqM4NbuB502UFk+eUbVFmEmknHgA9GrqJ14TDhEV4ZeiOJd/OXXUvTtjI7vpuyXL4aae24fyXNmtSfs6sZGNyY79hwG2b7ggsfz56lytjEl1AI01Ynk44u2LGk0v1OLQXI4JlnQS4U6J/cBXi222srUdDinyScsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEJzdk4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEJzdk4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBCC4CEEA;
	Mon, 23 Jun 2025 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684466;
	bh=U5WYrlJPlkAZnLyFhwzh20EV6jqB44qBGpWaI2giGVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEJzdk4CUYkma+anMoy7lKmqwkUUb0IkCngyO55azA3Rr7LbeS2XQA0BXfJbanm7q
	 WBMax7MD/t8S/fHV4brD/k1IE3qYYWUxPQnAqmVroE5V0t5zw9XhTJXvPIc6aCQnp7
	 mVXoH5SfRVdQ0/WCo9TF6H36RDPeGc440APEFph0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.15 024/592] s390/pci: Prevent self deletion in disable_slot()
Date: Mon, 23 Jun 2025 14:59:42 +0200
Message-ID: <20250623130700.809083454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

commit 47c397844869ad0e6738afb5879c7492f4691122 upstream.

As disable_slot() takes a struct zpci_dev from the Configured to the
Standby state. In Standby there is still a hotplug slot so this is not
usually a case of sysfs self deletion. This is important because self
deletion gets very hairy in terms of locking (see for example
recover_store() in arch/s390/pci/pci_sysfs.c).

Because the pci_dev_put() is not within the critical section of the
zdev->state_lock however, disable_slot() can turn into a case of self
deletion if zPCI device event handling slips between the mutex_unlock()
and the pci_dev_put(). If the latter is the last put and
zpci_release_device() is called this then tries to remove the hotplug
slot via zpci_exit_slot() which will try to remove the hotplug slot
directory the disable_slot() is part of i.e. self deletion.

Prevent this by widening the zdev->state_lock critical section to
include the pci_dev_put() which is then guaranteed to happen with the
struct zpci_dev still in Standby state ensuring it will not lead to
a zpci_release_device() call as at least the zPCI event handling code
still holds a reference.

Cc: stable@vger.kernel.org
Fixes: a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/s390_pci_hpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -65,9 +65,9 @@ static int disable_slot(struct hotplug_s
 
 	rc = zpci_deconfigure_device(zdev);
 out:
-	mutex_unlock(&zdev->state_lock);
 	if (pdev)
 		pci_dev_put(pdev);
+	mutex_unlock(&zdev->state_lock);
 	return rc;
 }
 


