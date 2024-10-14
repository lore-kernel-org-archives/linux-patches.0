Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C9610B;
	Mon, 14 Oct 2024 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916286; cv=none; b=famoXYQbGYgEFa4sj5KLVMDgsbCra/jqZS5m+5A6HKZCSJV7CH7Q3ZvnqKO8SVSdSF/ObdPFqgS7lUi3PW9bLuHAJKeB8qGO8wtQFdIf5gOflwKDtAIZ1gv1L5Nsr/MQcLRwvVBBG3K3Rr7dv12EExUmGgP3kmlqozHLhYBPvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916286; c=relaxed/simple;
	bh=MXSzCKLQAdXceDzDIZVTulgI1Gqw8KcLevriScat/KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m94qzRe4zg7tDHQe4HfQKnTcrmT5GSHER633KIEJrnZ291Iv2MA7kVL0A6ZXic1ztp36KFKREIO2+FxZQf/pcr1YlXbJOwq7p+GsC8WJDut24G5fyPHIPpBkPL2PdosEbIiVkynRpL9D/n6011/C7YyXc+pa+N66gqb5v9Sg3JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMWHBTzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMWHBTzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87FC4CEC7;
	Mon, 14 Oct 2024 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916285;
	bh=MXSzCKLQAdXceDzDIZVTulgI1Gqw8KcLevriScat/KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMWHBTzfsK6uxFQMU7bUOe8rQKh9Jzw0WMUpV3X4h43EtUgBkafpjRYeVro/BJ7ne
	 lrB0Njtmjfp4RdH+cqsfND/rXM0oBWkjiC3WxheMeGUxxHD8id+l5ZM0W4EoK5FHQ/
	 LQ5egVrzOM9O9G7vdNGVxLcICLXKIWoDq6yqJras=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 138/214] net: netconsole: fix wrong warning
Date: Mon, 14 Oct 2024 16:20:01 +0200
Message-ID: <20241014141050.375288234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d94785bb46b6167382b1de3290eccc91fa98df53 ]

A warning is triggered when there is insufficient space in the buffer
for userdata. However, this is not an issue since userdata will be sent
in the next iteration.

Current warning message:

    ------------[ cut here ]------------
     WARNING: CPU: 13 PID: 3013042 at drivers/net/netconsole.c:1122 write_ext_msg+0x3b6/0x3d0
      ? write_ext_msg+0x3b6/0x3d0
      console_flush_all+0x1e9/0x330

The code incorrectly issues a warning when this_chunk is zero, which is
a valid scenario. The warning should only be triggered when this_chunk
is negative.

Fixes: 1ec9daf95093 ("net: netconsole: append userdata to fragmented netconsole messages")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241008094325.896208-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 9c09293b52588..3e68f7a6e0abe 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1118,8 +1118,14 @@ static void send_ext_msg_udp(struct netconsole_target *nt, const char *msg,
 
 			this_chunk = min(userdata_len - sent_userdata,
 					 MAX_PRINT_CHUNK - preceding_bytes);
-			if (WARN_ON_ONCE(this_chunk <= 0))
+			if (WARN_ON_ONCE(this_chunk < 0))
+				/* this_chunk could be zero if all the previous
+				 * message used all the buffer. This is not a
+				 * problem, userdata will be sent in the next
+				 * iteration
+				 */
 				return;
+
 			memcpy(buf + this_header + this_offset,
 			       userdata + sent_userdata,
 			       this_chunk);
-- 
2.43.0



