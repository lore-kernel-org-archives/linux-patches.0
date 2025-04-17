Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0E51DB148;
	Thu, 17 Apr 2025 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913895; cv=none; b=keAT0Vjwgp43aKza48zKIyFYIpq8pmwbemnD3lUDwgzNSQDM1HllkqWsV30Tj/scVCSYpK9TvUO4Pqxc3OgoANDT60rsyge1omXH2XzlFOJgXJibNXzgCl73LsaZANK/5BhrEMp52r8mKIUhFd0X+rBrVBOPqxqQgYk09qa65jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913895; c=relaxed/simple;
	bh=kfnmt0If4XWFCaP9DyxzUnkRYaiQOz91LbYwKEa8gu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed1VwkTRgDZrjxFTKAclQ54MrIV9wH38ogcCOBCWFbwThvkugbIqf9/HxAYwrbCHB8iWRsDEZeycJrvXvFWUCL0K3ij4zTIkEDa/btqc3bdX6MY412YVXczG96KE4XQ60zeAQ3SDSINWMBXsIN2JlMZr8gHLqTaXEmpvjjbA4qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvCK0rZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvCK0rZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10497C4CEF1;
	Thu, 17 Apr 2025 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913895;
	bh=kfnmt0If4XWFCaP9DyxzUnkRYaiQOz91LbYwKEa8gu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvCK0rZT/ek/ihbRw8Uj3VqaI9PYovKUqVrrtajejAKHICe9fEDUmskvdmiSq/Oze
	 /aSivwdOxdkngXbr+qInxTACIEfHGT6bcaf/U54Qp0QfMT6uyI4ekkwNL+oRfR4qx7
	 7IpSrPonFRu2aW4AelYnaBF6kCsRDXNveYMyYZEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 037/414] ethtool: cmis_cdb: Fix incorrect read / write length extension
Date: Thu, 17 Apr 2025 19:46:35 +0200
Message-ID: <20250417175112.907940973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



