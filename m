Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1BC2E7373;
	Sun,  7 Jun 2026 10:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827258; cv=none; b=fGRY5IshR3y6EWEWRPIMSZN5QskYHra4FPikBNvuYo0WyY92a7B/6DWSjpafoLD2DHDo8BKTULA7S5IneicHhuYULW9yy2AwKyhqRaU2iUFBC9strjGfPBjZx7HuVj89v8hDhUR0ofej2Eq4mF2yiXyjZ6J9W/qW0e2mkFU5a7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827258; c=relaxed/simple;
	bh=KDiqfulrI7AzqYDG5qOhhO3SzLhqgQdx/czQtqEij7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aif5N/qHJbr6irlNgjCOBFtgPAS/9Cy56QfcKqJvoOUuhxcO3psM9pINhpFUq5b0covCteYE/cu/OVahYbXDz/bKIelBP+QABsWKDdY0JiwbMO87b1ylJgiqxlWQaGvVO7o9QP3M87UOo6vGl2gihBSIbBiIMUxXuYJ+Jhr1Gvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6UQteVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6UQteVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4291F00893;
	Sun,  7 Jun 2026 10:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827257;
	bh=YGyxuzZbC4vlPv9xRFI/4Y0j3hAsJSzKnWTLu4IY0pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6UQteVvnmh9EReAQHHTkQms9EP1krA8R+Ix7JxSnAeunVyeXLmbORDFtmMP8iWKh
	 TLgSrqPQDA1t1MNlXrE4Wme/9WTfq5DfwDCgzFJL+vmLqiXEXxp2hotDQTxj50ql2x
	 C2MPiJLK6Ls+3xJS6YvKWm6KJAbOUvwMgHPcGiQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 053/332] ethtool: cmis: fix u16-to-u8 truncation of msleep_pre_rpl
Date: Sun,  7 Jun 2026 11:57:02 +0200
Message-ID: <20260607095730.073996594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4a9a946cabf05d..778783a0f23c0b 100644
--- a/net/ethtool/cmis.h
+++ b/net/ethtool/cmis.h
@@ -63,9 +63,9 @@ struct ethtool_cmis_cdb_request {
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
@@ -73,8 +73,8 @@ struct ethtool_cmis_cdb_request {
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



