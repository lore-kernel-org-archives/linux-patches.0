Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7942A1649C3;
	Mon, 29 Jan 2024 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548438; cv=none; b=DiZTrdKxx4EtA05ALeXinjq/Mj4o0zOksKaIQTyVaCcAL1QexbbALpbpn6m4+o218Zd4uihlI49zqU8ltSiStFW2qK03ciaGV+D5H53YR0gAVNeQbjYq18T/8m22zryUjpnf8KPwMJK2q3302So2gRI+DMkTesraIglYvYPU15s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548438; c=relaxed/simple;
	bh=y+7THTwz2tfP6tj9wmcjpAzpbbym6I65URrAykB5GvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqE4JgPSQ3S3c2l5gT/Cmq1NshKgKXuwW8Ipt5JB4HUKXZMt5SC+fTbbi3GhND8d0JAHdJPvx2Z/awNO4tpqG00X0UGiHFLUenbrmJIfT4j9Wgl9OxuK+OZAQXL16RBSnV0lIbrSNNTqjoQzLH8KNMqAgUJdlWhuV7+M2/QlYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi+ZxVIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi+ZxVIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F16C433C7;
	Mon, 29 Jan 2024 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548438;
	bh=y+7THTwz2tfP6tj9wmcjpAzpbbym6I65URrAykB5GvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi+ZxVIpeUCUO+HuIGtbiSBG4GMKElmYcFsQGJ/dN03g3/5+zxSSxpcUEvUlYu9xT
	 BZCwoGQ2ShBIQyvpeVv7G98V5NGwLCVQUMoaPE7D3Mg61gYOMZhEToiadT/FzdWb+D
	 siTzeR2d2SJMnaCOr1jLWwLWJNoPISRXXondXhzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janosch Frank <frankja@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.6 043/331] s390/vfio-ap: unpin pages on gisc registration failure
Date: Mon, 29 Jan 2024 09:01:47 -0800
Message-ID: <20240129170016.200959096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 7b2d039da622daa9ba259ac6f38701d542b237c3 upstream.

In the vfio_ap_irq_enable function, after the page containing the
notification indicator byte (NIB) is pinned, the function attempts
to register the guest ISC. If registration fails, the function sets the
status response code and returns without unpinning the page containing
the NIB. In order to avoid a memory leak, the NIB should be unpinned before
returning from the vfio_ap_irq_enable function.

Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231109164427.460493-2-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_ir
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
 				 __func__, nisc, isc, q->apqn);
 
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_GISA;
 		return status;
 	}


