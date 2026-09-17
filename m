Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF294E36FD;
	Thu, 17 Sep 2026 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665525; cv=none; b=aAQD8L+RzOdj3DHMANQS5lqJlrAZXqM0EpJVgnmDVZ3SAozC7UKOtrrEZ3T2VfgodTaDHUrZRToqqKDfXVf0cBzATSMs5rcgGLoXEcUyClVQ+BCdhcQAZKY8V/dFPVtThSjvop9KWhpGm8b5bvvyAzf/hbJh4gvzcZgTNs1qQxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665525; c=relaxed/simple;
	bh=xhg0VWYIfQXNGQ0Xcq35+yGaE1ESowlC5o4X1xB9BjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1AUZSAs2dXsVYqeI6RtT8wVN63/FL3r5FD3Gwbi2+UzbiRpAPIKBIDqw9jHaK5fzYNjX5eFj3+sohlDHbBcso6n+yTMqH/fUq1M8FlKQuuBd0lCWPbGNm+juGO4NQh0NvzKMpp7q/W4HZKzERKMwwF9qvhMTyNKSkiQP6sK5BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRU2okFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRU2okFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BE71F000FF;
	Thu, 17 Sep 2026 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665524;
	bh=fmNHcMA46WPj4vKvd4FzuOMPpWIGOYld6O/OpngJg/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRU2okFJgk0i+kv5av9Jm/nHLUTxZ/ysU+/ahKRgdjHml0aJcNpDB/p/NVEEmc/yX
	 u1wKhLXs+ZJggDY5cr3QS7IDiZKNvS6M4Ac+SClqiJBaeA+D2PeM4ygvKnZiSfI6Iu
	 UgIu7gcrLUj4Cyh3NIPRzuJUGfdo56rw1b97TbPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0694/1250] s390/boot: Avoid IPL parameter append past command line
Date: Thu, 17 Sep 2026 16:08:09 +0100
Message-ID: <20260917151610.700778044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit d76181dfabdaa720703167393704efacba343442 ]

A command line may occupy all but the terminating byte of
COMMAND_LINE_SIZE. In that case append_ipl_block_parm() passes a zero size
to the IPL parameter conversion helpers and points the destination one
byte past early_command_line. The helpers subtract one from the unsigned
size and write the converted parameter outside the command line buffer.

Convert the IPL parameter in the command line parsing buffer first. A
parameter beginning with '=' can then replace the existing command line
regardless of its length, while other parameters are appended only when
space remains.

Fixes: 5ecb2da660ab ("s390: support command lines longer than 896 bytes")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index f584d7da29cb2..45c687be4b53b 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -22,6 +22,7 @@ struct parmarea parmarea __section(".parmarea") = {
 };
 
 char __bootdata(early_command_line)[COMMAND_LINE_SIZE];
+static char command_line_buf[COMMAND_LINE_SIZE];
 
 unsigned int __bootdata_preserved(zlib_dfltcc_support) = ZLIB_DFLTCC_FULL;
 struct ipl_parameter_block __bootdata_preserved(ipl_block);
@@ -134,31 +135,29 @@ static size_t ipl_block_get_ascii_scpdata(char *dest, size_t size,
 
 static void append_ipl_block_parm(void)
 {
-	char *parm, *delim;
-	size_t len, rc = 0;
+	size_t len, extra = 0;
+	char *delim;
 
 	len = strlen(early_command_line);
-
-	delim = early_command_line + len;    /* '\0' character position */
-	parm = early_command_line + len + 1; /* append right after '\0' */
+	delim = early_command_line + len; /* '\0' character position */
 
 	switch (ipl_block.pb0_hdr.pbt) {
 	case IPL_PBT_CCW:
-		rc = ipl_block_get_ascii_vmparm(
-			parm, COMMAND_LINE_SIZE - len - 1, &ipl_block);
+		extra = ipl_block_get_ascii_vmparm(command_line_buf, sizeof(command_line_buf), &ipl_block);
 		break;
 	case IPL_PBT_FCP:
 	case IPL_PBT_NVME:
 	case IPL_PBT_ECKD:
-		rc = ipl_block_get_ascii_scpdata(
-			parm, COMMAND_LINE_SIZE - len - 1, &ipl_block);
+		extra = ipl_block_get_ascii_scpdata(command_line_buf, sizeof(command_line_buf), &ipl_block);
 		break;
 	}
-	if (rc) {
-		if (*parm == '=')
-			memmove(early_command_line, parm + 1, rc);
-		else
+	if (extra) {
+		if (command_line_buf[0] == '=') {
+			memmove(early_command_line, command_line_buf + 1, extra);
+		} else if (len < COMMAND_LINE_SIZE - 2) {
 			*delim = ' '; /* replace '\0' with space */
+			sized_strscpy(delim + 1, command_line_buf, COMMAND_LINE_SIZE - len - 1);
+		}
 	}
 }
 
@@ -244,7 +243,6 @@ static void modify_fac_list(char *str)
 	check_cleared_facilities();
 }
 
-static char command_line_buf[COMMAND_LINE_SIZE];
 void parse_boot_command_line(void)
 {
 	char *param, *val;
-- 
2.53.0



