Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD722D7393;
	Wed, 25 Feb 2026 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002685; cv=none; b=g30mHXW88BtVCulknDJnpb5x9X1FeaLm2slf1qk7JFroEdmc89us+U6XBAgccJb/G64/UJU6vdfzplwrdYt6YvDwYK+tsmgfwV3dA+WXBxLIs5UbOlLRxjDoXBx0Y22sk5y4FnOzllqIn4MK+TercdTF0K3PsvjkTlu20FuiQTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002685; c=relaxed/simple;
	bh=rvaVnrRrQlurWo9qM3KHSYS6NdxoS9I2RDFkYJGXQG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n56233xEGfF6NRQChW8IunhfRYVWlvLuOnhK5JlfUNyL5hjX/Oi1hh4H0TBRu2MLJfnt0fr0r+9WLq+0jFWB9MhWDE7oCwgelZ7MtUpum6G/dlyPj7vPPG8z+3ICOp9IPzB5I+8aWlLhi7Nv05dwwFzTxZGJpLyTTEKITign9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8bvBCZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8bvBCZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4218C19425;
	Wed, 25 Feb 2026 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002685;
	bh=rvaVnrRrQlurWo9qM3KHSYS6NdxoS9I2RDFkYJGXQG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8bvBCZmeTRvZ+qwKHcAiCdTlCxTCNSFS2+046BhZRKA+W7HwWWdKrsSXBkGbC6ik
	 PijFCExLqoR4QWUKwLffLwE3NY1YfbLL5V/cSUxVzZyfpqVSIiRUHEzSGxXUnZbfjL
	 U+Qq3p5AirJciqfKBQYnoMCRL3Etd9+KuWZSPEBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/641] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Tue, 24 Feb 2026 17:23:23 -0800
Message-ID: <20260225012400.076562067@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4feb753ba6e5e5bbaba868b841a2db41c21e56fa ]

The wm5102_clear_write_sequencer() helper may return an error
and just return, bypassing the cleanup sequence and causing
regulators to remain enabled, leading to a resource leak.

Change the direct return to jump to the err_reset label to
properly free the resources.

Fixes: 1c1c6bba57f5 ("mfd: wm5102: Ensure we always boot the device fully")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251214145804.2037-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 85ff8717d8504..91975536d14d2 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1100,7 +1100,7 @@ int arizona_dev_init(struct arizona *arizona)
 		} else if (val & 0x01) {
 			ret = wm5102_clear_write_sequencer(arizona);
 			if (ret)
-				return ret;
+				goto err_reset;
 		}
 		break;
 	default:
-- 
2.51.0



