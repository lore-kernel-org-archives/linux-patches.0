Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027439;
	b=dbMfV0UmtsOaDkbXkMF/r/USzBurQjLU+lt7CyFTpRzQq5vnfyl/p2/xJpxTsxXAvQk6
	 XJWTa+sENAbaWjomVd0HDyoApen3DUKrIawUjJD2dnLNFfM1r7tlg/JGEAU01PyYDvV3+
	 ECxhq7cJTXM8oE/aoY2bXZnVkYRT4Glta5eqqwilt9x39OAo/y5PSBGAR2G8DIY6WVxhX
	 cWg1OEdhe3ahiJExmCcwCYmaPP+bkemBSnLZKBuJEOVuiYzajTz7OD/YIhcCDMco/9sTr
	 rafDCX+HabPlIWazojZzHbYmfC7fB+r8mJi8zEtN6db1Zs4RMTjdYhUVrYhe/AG/AZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ab32DKjQZ6bXiLEUwVh4KMl2VLsRXF9pF8A1flG6LkA=;
	b=h2q8JRqBVpSTX/lCOLQoEkiYi8M0uMOeoD1B30l+i0fdwjUk0A/QeW9sZaXMx3ulRt4i
	 o19EkDQleURkeyjKZcXoyxWG6FdXj8CYwXOzp22XStOuex/gecJr7VUa/pNt+waL9wSUJ
	 mUfo+OrkIgyEbbp/IVCHWAQsYAN/0J4hdUGL5yt55B3/HB5y0zQhxX9qXWmEMD3DlpZ/g
	 FdzLyC6miyi8bh5mcO0KvSvAMVQE1zzCB8vs8yZi5nQBgOHfO36al4faTUFhXOtdduiZk
	 v+CPc4UsAxadrLrb66fMR7zpEPi/y0BOXiJKL8WIFl84MWDHITR9Y49nRn93MNje0hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlj37Sde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667660A2611;
	Wed, 18 Nov 2026 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlj37Sde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7F51F000C4;
	Wed, 18 Nov 2026 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027439;
	bh=ab32DKjQZ6bXiLEUwVh4KMl2VLsRXF9pF8A1flG6LkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlj37SdegC10255NPSPRkhSGuhyrdVWOnwgVPkAdfIcJqjY/WhGw4D9hbjg6OtYTo
	 Tkn4ZG/AuiPMYbyLD8FDZXm8CboxxUXXYrnnTh1IgfYmQqZBaqydCd3p7SKA7NYhmC
	 N/lqA++HbG7jJq1cYmOuzJeR4VHKsMxkJL9QukNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1791/2151] ipe: fix enforcement audit
Date: Wed, 18 Nov 2026 15:58:46 +0100
Message-ID: <20261118150227.060285733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <wufan@kernel.org>

[ Upstream commit 0e5f66bf052223aa5c8caeb8554a7577b54c302f ]

ipe_audit_enforce() starts an audit buffer but writes the state change
with audit_log(), which logs its own record. Ending the unused buffer
then emits an extra empty AUDIT_MAC_STATUS record.

Remove the unused buffer and log the state change with audit_log()
alone.

Fixes: a68916eaedcd ("ipe: add permissive toggle")
Assisted-by: LLM
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/ipe/audit.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index de5fed62592e1..97f76ecee8561 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -261,18 +261,10 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
  */
 void ipe_audit_enforce(bool new_enforce, bool old_enforce)
 {
-	struct audit_buffer *ab;
-
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
-	if (!ab)
-		return;
-
 	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS,
 		  "enforcing=%d old_enforcing=%d auid=%u ses=%u"
 		  " enabled=1 old-enabled=1 lsm=ipe res=1",
 		  new_enforce, old_enforce,
 		  from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		  audit_get_sessionid(current));
-
-	audit_log_end(ab);
 }
-- 
2.53.0



