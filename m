Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DA26139A;
	Thu, 17 Apr 2025 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912626; cv=none; b=oneP/+X0XOqwtEJ3gOQUfmrLbxe/D41djDbBwS5RVwFZXGQyduG9CGvXI9flg93gryQooXjbuTJZjNqgujnu/WPLNQFHqX/IZAf+XNDscM+BEpKNo2bow3CJIcFyk8eC/o1W3ClmlqOYrTHmEHHEph4XKDMgnCE7s50xq1L/6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912626; c=relaxed/simple;
	bh=471/7iQIgtqJmwiJuLNFM1QfJ2PCofe7DpmnG2vG4Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtRE3gimAAPZ6pgJQ42J9TUYUz+CwouWWcbAwg8KL43FrWHeuzRkb8M4DCQMI2f/Xn0fWOoP+k3b5/d6Xh8nFoVQKjXytJkjcSmWLl+G8tmlObPYYeoB4lQiDnQJEy/K/DzTW7Vz0Y8BEqu4hgj6iMikgRqxeKRBjVQdO1hb7S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLrgzCFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLrgzCFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0228FC4CEE4;
	Thu, 17 Apr 2025 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912626;
	bh=471/7iQIgtqJmwiJuLNFM1QfJ2PCofe7DpmnG2vG4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLrgzCFhEdwFsmEZXgYPUT13/VKwZmjN6rZwG1KRYFqVKprtdpjEQoN0VTeHGUu/j
	 /8oPSzEsCJBFf/mGemFQHkGLqVFMVc2JMdnZIB5lGavmMLe4ZTXjzLRmiqTIH8QzEt
	 bsnMPL3sZBcy+s0owdik+S+zYnWP1L4w9oocNZKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 043/449] ethtool: cmis_cdb: Fix incorrect read / write length extension
Date: Thu, 17 Apr 2025 19:45:31 +0200
Message-ID: <20250417175119.720681955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit eaa517b77e63442260640d875f824d1111ca6569 ]

The 'read_write_len_ext' field in 'struct ethtool_cmis_cdb_cmd_args'
stores the maximum number of bytes that can be read from or written to
the Local Payload (LPL) page in a single multi-byte access.

Cited commit started overwriting this field with the maximum number of
bytes that can be read from or written to the Extended Payload (LPL)
pages in a single multi-byte access. Transceiver modules that support
auto paging can advertise a number larger than 255 which is problematic
as 'read_write_len_ext' is a 'u8', resulting in the number getting
truncated and firmware flashing failing [1].

Fix by ignoring the maximum EPL access size as the kernel does not
currently support auto paging (even if the transceiver module does) and
will not try to read / write more than 128 bytes at once.

[1]
Transceiver module firmware flashing started for device enp177s0np0
Transceiver module firmware flashing in progress for device enp177s0np0
Progress: 0%
Transceiver module firmware flashing encountered an error for device enp177s0np0
Status message: Write FW block EPL command failed, LPL length is longer
	than CDB read write length extension allows.

Fixes: 9a3b0d078bd8 ("net: ethtool: Add support for writing firmware blocks using EPL payload")
Reported-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Closes: https://lore.kernel.org/netdev/20250402183123.321036-3-michael.chan@broadcom.com/
Tested-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20250409112440.365672-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis.h     |  1 -
 net/ethtool/cmis_cdb.c | 18 +++---------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/ethtool/cmis.h b/net/ethtool/cmis.h
index 1e790413db0e8..4a9a946cabf05 100644
--- a/net/ethtool/cmis.h
+++ b/net/ethtool/cmis.h
@@ -101,7 +101,6 @@ struct ethtool_cmis_cdb_rpl {
 };
 
 u32 ethtool_cmis_get_max_lpl_size(u8 num_of_byte_octs);
-u32 ethtool_cmis_get_max_epl_size(u8 num_of_byte_octs);
 
 void ethtool_cmis_cdb_compose_args(struct ethtool_cmis_cdb_cmd_args *args,
 				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *lpl,
diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index d159dc121bde5..0e2691ccb0df3 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -16,15 +16,6 @@ u32 ethtool_cmis_get_max_lpl_size(u8 num_of_byte_octs)
 	return 8 * (1 + min_t(u8, num_of_byte_octs, 15));
 }
 
-/* For accessing the EPL field on page 9Fh, the allowable length extension is
- * min(i, 255) byte octets where i specifies the allowable additional number of
- * byte octets in a READ or a WRITE.
- */
-u32 ethtool_cmis_get_max_epl_size(u8 num_of_byte_octs)
-{
-	return 8 * (1 + min_t(u8, num_of_byte_octs, 255));
-}
-
 void ethtool_cmis_cdb_compose_args(struct ethtool_cmis_cdb_cmd_args *args,
 				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *lpl,
 				   u8 lpl_len, u8 *epl, u16 epl_len,
@@ -33,19 +24,16 @@ void ethtool_cmis_cdb_compose_args(struct ethtool_cmis_cdb_cmd_args *args,
 {
 	args->req.id = cpu_to_be16(cmd);
 	args->req.lpl_len = lpl_len;
-	if (lpl) {
+	if (lpl)
 		memcpy(args->req.payload, lpl, args->req.lpl_len);
-		args->read_write_len_ext =
-			ethtool_cmis_get_max_lpl_size(read_write_len_ext);
-	}
 	if (epl) {
 		args->req.epl_len = cpu_to_be16(epl_len);
 		args->req.epl = epl;
-		args->read_write_len_ext =
-			ethtool_cmis_get_max_epl_size(read_write_len_ext);
 	}
 
 	args->max_duration = max_duration;
+	args->read_write_len_ext =
+		ethtool_cmis_get_max_lpl_size(read_write_len_ext);
 	args->msleep_pre_rpl = msleep_pre_rpl;
 	args->rpl_exp_len = rpl_exp_len;
 	args->flags = flags;
-- 
2.39.5



