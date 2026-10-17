Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE4374E60;
	Sat, 17 Oct 2026 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258909; cv=none; b=M5ngSNyzAsrMQQKdt+ECZRV1zIW/H99YwEy//Dmfs9Vqas5lnWsBTBgyQIoJk2OPyv3L+YEUFBDpYB13o0zrSvmJ9yR5mzAUc9fVwadkMpG9h5E760+qha3KAHRsq7HixaVks6O/1wluSmigeFj2ACoPBRZ18zLaSz3XYZRG1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258909; c=relaxed/simple;
	bh=joUrcz282Rgsh+KJu1oQpdW1IQt37ABzcUEaOTDigOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc8eYoyKznEyj657IrkNXbd8PuqiWXak3xtui6spYf9jWbXEoT3Lek7x4ATb8V2DyfPiQNFri88KDhl9WLriRYGXEn6P77TEThmqBXNMBYnv4EMHz0nyUGAyRXHBmPIpqyxGDVsjdFBjZsPOnMyUYa/VlvjvkLCo0GcABBDB+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye/Rnd1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye/Rnd1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810A91F000C4;
	Sat, 17 Oct 2026 17:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258908;
	bh=b4icOcuKSApQot3A/mMCOlCNGMmzY1cAv21VRMmaJ6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye/Rnd1mcVXz/FZ+JHbwdTzMFrySlvxoq3v9UmvpxgLGYzFQ92cBDLgYBjYmq669c
	 sIyiiMToUPXbdgrJLrCuTFsijDaoA+X76poHeqgllwtyzs7vG+356XBbUyNvI31i3j
	 5iI/BtE9QN6waoivUw6JopmUA31hh93dxlu7Mu/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1039/1674] usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers
Date: Sat, 17 Oct 2026 17:55:11 +0200
Message-ID: <20261017160457.803110118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 8fbc349e8383125dd2d8de1c1e926279d398ab17 ]

Properly validate the count passed from a device when calling
svdm_consume_identity() or svdm_consume_identity_sop_prime() as the
device-controlled value could index off of the static arrays, which
could leak data.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/2026051350-plated-salute-0efe@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index d93393aeb2f49..cac8f8167aa8a 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1485,6 +1485,9 @@ static void svdm_consume_identity(struct tcpm_port *port, const u32 *p, int cnt)
 	u32 vdo = p[VDO_INDEX_IDH];
 	u32 product = p[VDO_INDEX_PRODUCT];
 
+	if (cnt <= VDO_INDEX_PRODUCT)
+		return;
+
 	memset(&port->mode_data, 0, sizeof(port->mode_data));
 
 	port->partner_ident.id_header = vdo;
-- 
2.53.0



