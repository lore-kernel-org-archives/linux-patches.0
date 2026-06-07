Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9EE4071DA;
	Sun,  7 Jun 2026 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827424; cv=none; b=UhkfFsS86N7v+wvmrIqQrVuKYNHF/U531p8J9E5E2HjIdLLgpeycyFKvboekZAx1bOWu2RbXAj8zNvFanLU0Ec+AyoH2opMBrNSVc+l9wQqOn/NdY1lsIVqDm2XdW11HEz4yQL6OQPl4TehEyxZRovUoLNUD1aJ0gB9RxWbqMtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827424; c=relaxed/simple;
	bh=ZWPJKjpWQlllb6X17s1+2AuiY6iR9Mf+IA5BI0BD39g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLZjozRFAbTzfwANjAIn5GIq1figLZ1q8MMIFa/j/zdHxHL0YdPCLvYYxYRrcX+4yK48da5uPvlhxFDEmeSdBHdlVT2o/6S/uLe0lChtmHevvWGYaYgcV7nPzoWbb6GkBW3VFLUZIIAg6IOEOCu9A5ohaNjHHDsHgZmnwdbkmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANBFoCxa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANBFoCxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF151F00893;
	Sun,  7 Jun 2026 10:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827423;
	bh=2QJ4ALtNWjns4tIVkOCM56Sk6dLZyJ2dcEFzCrlrVE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANBFoCxaAKmmYRSAyZFK9Cp67QOifQmtpgg4vUMdx+ukrW41dFuTttp688r8cR2V/
	 Ut+fYytf42Jjs0MrXfXW5+sMwZ5Uj6XTKpQpvXldZ9sykJ7JBjwN3IS7zDldpu82bQ
	 EzaFU+r/otDswQCXr3STq3be82FkPX/9We5OFyvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/307] ethtool: cmis: fix u16-to-u8 truncation of msleep_pre_rpl
Date: Sun,  7 Jun 2026 11:57:31 +0200
Message-ID: <20260607095729.710386624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3e8c3d464c36bb342fe377b026577c7ec27fdbb4 ]

ethtool_cmis_cdb_compose_args() accepts msleep_pre_rpl as u16 but stores
it into the u8 field ethtool_cmis_cdb_cmd_args::msleep_pre_rpl, silently
truncating values >= 256. Seven of the nine call sites pass 1000 ms
(it's the third argument from the end).

Fixes: a39c84d79625 ("ethtool: cmis_cdb: Add a layer for supporting CDB commands")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/cmis.h b/net/ethtool/cmis.h
index 3e7c293af78c4d..aa32a675b8f8d2 100644
--- a/net/ethtool/cmis.h
+++ b/net/ethtool/cmis.h
@@ -59,9 +59,9 @@ struct ethtool_cmis_cdb_request {
  * struct ethtool_cmis_cdb_cmd_args - CDB commands execution arguments
  * @req: CDB command fields as described in the CMIS standard.
  * @max_duration: Maximum duration time for command completion in msec.
+ * @msleep_pre_rpl: Waiting time before checking reply in msec.
  * @read_write_len_ext: Allowable additional number of byte octets to the LPL
  *			in a READ or a WRITE commands.
- * @msleep_pre_rpl: Waiting time before checking reply in msec.
  * @rpl_exp_len: Expected reply length in bytes.
  * @flags: Validation flags for CDB commands.
  * @err_msg: Error message to be sent to user space.
@@ -69,8 +69,8 @@ struct ethtool_cmis_cdb_request {
 struct ethtool_cmis_cdb_cmd_args {
 	struct ethtool_cmis_cdb_request req;
 	u16				max_duration;
+	u16				msleep_pre_rpl;
 	u8				read_write_len_ext;
-	u8				msleep_pre_rpl;
 	u8                              rpl_exp_len;
 	u8				flags;
 	char				*err_msg;
-- 
2.53.0



