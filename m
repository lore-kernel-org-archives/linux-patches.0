Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D01F3A1B6;
	Mon, 14 Oct 2024 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919912; cv=none; b=LRqZ4FlCBUd7ckaSdTc4jmtscUVcSrPohLkkjIrBO616ASxOVSNenWj2iLfWihM+T4VdzwwIAzR469soX9BNR4OoduV77oFZqQaBQ1sc01+0vsjlJkS1MBRIzVq/BRXzPbAufCQMrGwkh0s7tYqxydZ7/nVFYLcsalz5NhCY79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919912; c=relaxed/simple;
	bh=IAwf/MsV4gITRTPX1pl/3hmwEQivFKxTKmXWdXpS4ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TksC7O4A8Z8FmUfRilyXbQXJitf7qX9sMbZn79ZwfmyldHQTQGc23e6n+HuDKzc0RuoEq4dL4vIOTC5hTE7jGKaeq+OMYEs1s2B67z/tSU7XFdtwIAFlZWdxEkJ7QH6600zW+Im0vBbMpd6SWjBJLM951CpNOak1+c+xHwkCcPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuJXkLlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuJXkLlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5699C4CEC3;
	Mon, 14 Oct 2024 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919912;
	bh=IAwf/MsV4gITRTPX1pl/3hmwEQivFKxTKmXWdXpS4ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuJXkLlW3TwYXUt+dvg1aD+5ibJBt7YcnfRvEDJ112FZkT4eZjzW/F1O6QBEna+gs
	 1ZaGuFVO+P0Y5dq2t2XkFvZ5TIaU56eK7xBapaAHNaoQ/vmhBAkyds3MFAeDtGbPjh
	 NqB59EpTdryF7TX+UohyYNHfDxvEdPF9l+zLIMv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 744/798] net: dsa: b53: fix max MTU for BCM5325/BCM5365
Date: Mon, 14 Oct 2024 16:21:38 +0200
Message-ID: <20241014141247.300065860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit ca8c1f71c10193c270f772d70d34b15ad765d6a8 ]

BCM5325/BCM5365 do not support jumbo frames, so we should not report a
jumbo frame mtu for them. But they do support so called "oversized"
frames up to 1536 bytes long by default, so report an appropriate MTU.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 82583edbb3f95..28b58dee6b8cd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -225,6 +225,7 @@ static const struct b53_mib_desc b53_mibs_58xx[] = {
 
 #define B53_MIBS_58XX_SIZE	ARRAY_SIZE(b53_mibs_58xx)
 
+#define B53_MAX_MTU_25		(1536 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 #define B53_MAX_MTU		(9720 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 
 static int b53_do_vlan_op(struct b53_device *dev, u8 op)
@@ -2235,6 +2236,11 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
+	struct b53_device *dev = ds->priv;
+
+	if (is5325(dev) || is5365(dev))
+		return B53_MAX_MTU_25;
+
 	return B53_MAX_MTU;
 }
 
-- 
2.43.0



