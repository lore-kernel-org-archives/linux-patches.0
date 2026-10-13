Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71214F93D8;
	Tue, 13 Oct 2026 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894773; cv=none; b=EnBelQtIODj7I6Hzd5uUSKQdALnt+XDpfb7BqlmHEIca+Ko9aqpnap3ift5aWL0qLvvdCAU7YnY0QaxeOLCJEok8EoZ+gk9oUq8fA04A+mVWM6m2xbSMN6Yh88D7h5Z115nPbCW4PDfV71BjY7B+KcSc47rs+vZN0OF5L32gC8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894773; c=relaxed/simple;
	bh=eieYo1RXg5X6vlbYuW1H3zrk6ZUq9EWbMW62PtxCBV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRxXoVKzZIgraVPn+uNVBtEFamHmNcHkSfI2zKgJiNym1DF2AnIJ2X8vuEFzBZ7MWOEk01F5PnC3tZlRsic2giorUeVDSZlyBSpaFTx5m7zt81xZDQEszm9wrSj6xedOUwaEq9cLU/eUoD/kjiXUxFqkTmHCICwcLNVPH2JBEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5JbucBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5JbucBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEC81F00893;
	Tue, 13 Oct 2026 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894771;
	bh=+sr2lRPorgQl5WTwTDJ1JxWBqW3IDAjulTLB0+ovs7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5JbucBRtqIMRUM3SgEMzJ22Zu3NgJA+jLHMJGKI9O2c/B0ixC9zzsfEDPg+pTGpc
	 ESqPqs/wGGnoNiEBmlMA98410LpDkmy0lcfx95T2UNPko4xJfiPjVPzbiAd2uqvqN5
	 UogzI5G4DpD5bnC+DMhQC9j7qyo9XS0ON/BNurGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/497] of/overlay: dont create "//" paths for fragments targeting the root
Date: Tue, 13 Oct 2026 13:33:39 +0200
Message-ID: <20261013112909.122042180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 21c89ff1fc86ffa517f3a9ca1ba5c48e9e37c1ba ]

dup_and_fixup_symbol_prop() rewrites a symbol value by replacing its
"/fragment/__overlay__" prefix with the fragment's target path. When
the fragment targets the root node the target path is "/" and the
result starts with "//", which __of_find_node_by_full_path() cannot
resolve: symbols pointing into such fragments silently stop
resolving.

Drop the target path when it is the root and the tail is non-empty. A
value naming the fragment root itself (empty tail) keeps the "/".

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-7-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index c4a8e925754d4..adc6a0277d6b7 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -250,6 +250,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc(sizeof(*new_prop), GFP_KERNEL);
 	if (!new_prop)
-- 
2.53.0



