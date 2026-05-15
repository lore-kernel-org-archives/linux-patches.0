Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8E3E008F;
	Fri, 15 May 2026 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861509; cv=none; b=E3LoYrtTxb6aeu9qHF4YCBEFfnOTR+WfY9XXJXv66cPqZCwFWyy19Xz19Jow/YwX9H7kXJhXeS15lGWkqpHbQaAThlmjhg645NCp/Km6c1xTuAPPg8Fg2WochqBOB+2GtvDlt4fFIy5bjHD3InWK/LHGLzdvmehvUkD5asJq4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861509; c=relaxed/simple;
	bh=lKn4lkghnPLtS96OWrO4n72S9cPa+XG9CSvrV60LMmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUa2YVqcxmoR8W3pyGJCIXw7RAdfzJS+meitm2Ib/FNTe8H4xLTciYDP2f2Y61IAUJMnQfmaIO475QfeE0dz+aC3O5Uk6UioA/my3ZaUx2eQm3/zNaoo2+/HRDHJdPMkAP80YAEGjIeBWQOxlt3frPmgEOcur2bNJMG6RnYFLfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXdYobsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXdYobsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A793FC2BCB0;
	Fri, 15 May 2026 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861509;
	bh=lKn4lkghnPLtS96OWrO4n72S9cPa+XG9CSvrV60LMmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXdYobsnwVMso1zdWTHWWFM8352b6tqFu3OwZr3X3f83Yz73bGfFA/QioUt3BvoC+
	 P4YFEyRWQuHz7H8RGYYeTmPupXMyttbLF7SN7sCsBRioSNVzII77/8VBZOHFZsVuld
	 2NsA3Ni+h+biDVoGB/yRqaOMN+lFPwiiJWLwbMzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 356/474] batman-adv: fix integer overflow on buff_pos
Date: Fri, 15 May 2026 17:47:45 +0200
Message-ID: <20260515154722.722110246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Lyes Bourennani <lbourennani@fuzzinglabs.com>

commit 0799e5943611006b346b8813c7daf7dd5aa26bfd upstream.

Fixing an integer overflow present in batadv_iv_ogm_send_to_if. The size
check is done using the int type in batadv_iv_ogm_aggr_packet whereas the
buff_pos variable uses the s16 type. This could lead to an out-of-bound
read.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Lyes Bourennani <lbourennani@fuzzinglabs.com>
Signed-off-by: Alexis Pinson <apinson@fuzzinglabs.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -334,7 +334,7 @@ static void batadv_iv_ogm_send_to_if(str
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	const char *fwd_str;
 	u8 packet_num;
-	s16 buff_pos;
+	int buff_pos;
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	struct sk_buff *skb;
 	u8 *packet_pos;


