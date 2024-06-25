Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AAA1487D6;
	Tue, 25 Jun 2024 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308209; cv=none; b=QehwrPe6tNw9KFZoNsPD5oxFhNINtjENyNDp9HGjx4dYLy0L24qGS6dXvUuF66rJv2HY3ZViN1yeGRleq868VpXdsoEwbk7xnIdzmaRi7wiJU4Wvr8tr1wG0q5GPMMi2jSBYZTOpcQV5Ani99r7/S5mapwKWGRYSI6UNHO3+bWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308209; c=relaxed/simple;
	bh=zJSkDOv/aft7eyTDMlzN6YadzLzBS9MDiweY1H9MdD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3EOi2Z7cWUpERg6uBczrwNWC2GvaiiPSWyEJQryTAIuFDDYbG2pYzy5Y7pTZF2hmpDlDaAEde4e6DUJ1wqbieL1f+gsUasDyf/9A511Y4TzJdDWR+zJlL1alJj75ntxeME5M09+tEcuB9FVfonUHIjqyQcLPrloUIRyhC7/lY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G81iK+v/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G81iK+v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA2FC32781;
	Tue, 25 Jun 2024 09:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308209;
	bh=zJSkDOv/aft7eyTDMlzN6YadzLzBS9MDiweY1H9MdD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G81iK+v/M02oJnEHntPyeRmmLbB91zT8XfCex5VJP5DW/wjVon8qhhHXN6x3ZsJCc
	 7bU4wL9mN2k+SXJXJzFTgS6zlXaCfGaD4byeDusL7w7r+8bE53z4IL63xe3Zf1T8px
	 2u1Za4IgvBwe09jZMdy2PB2CpoUheG4rNGByAHEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/250] selftests: net: fix timestamp not arriving in cmsg_time.sh
Date: Tue, 25 Jun 2024 11:30:02 +0200
Message-ID: <20240625085549.753118073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2d3b8dfd82d76b1295167c6453d683ab99e50794 ]

On slow machines the SND timestamp sometimes doesn't arrive before
we quit. The test only waits as long as the packet delay, so it's
easy for a race condition to happen.

Double the wait but do a bit of polling, once the SND timestamp
arrives there's no point to wait any longer.

This fixes the "TXTIME abs" failures on debug kernels, like:

   Case ICMPv4  - TXTIME abs returned '', expected 'OK'

Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240510005705.43069-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index c79e65581dc37..161db24e3c409 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -333,16 +333,17 @@ static const char *cs_ts_info2str(unsigned int info)
 	return "unknown";
 }
 
-static void
+static unsigned long
 cs_read_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 {
 	struct sock_extended_err *see;
 	struct scm_timestamping *ts;
+	unsigned long ts_seen = 0;
 	struct cmsghdr *cmsg;
 	int i, err;
 
 	if (!opt.ts.ena)
-		return;
+		return 0;
 	msg->msg_control = cbuf;
 	msg->msg_controllen = cbuf_sz;
 
@@ -396,8 +397,11 @@ cs_read_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 			printf(" %5s ts%d %lluus\n",
 			       cs_ts_info2str(see->ee_info),
 			       i, rel_time);
+			ts_seen |= 1 << see->ee_info;
 		}
 	}
+
+	return ts_seen;
 }
 
 static void ca_set_sockopts(int fd)
@@ -509,10 +513,16 @@ int main(int argc, char *argv[])
 	err = ERN_SUCCESS;
 
 	if (opt.ts.ena) {
-		/* Make sure all timestamps have time to loop back */
-		usleep(opt.txtime.delay);
+		unsigned long seen;
+		int i;
 
-		cs_read_cmsg(fd, &msg, cbuf, sizeof(cbuf));
+		/* Make sure all timestamps have time to loop back */
+		for (i = 0; i < 40; i++) {
+			seen = cs_read_cmsg(fd, &msg, cbuf, sizeof(cbuf));
+			if (seen & (1 << SCM_TSTAMP_SND))
+				break;
+			usleep(opt.txtime.delay / 20);
+		}
 	}
 
 err_out:
-- 
2.43.0



