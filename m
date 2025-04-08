Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623026A086;
	Tue,  8 Apr 2025 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113812; cv=none; b=TmOy+y66rOOF4u3kNxqZXmVukzCUjxe2+P37t1Dk4vPVsGUp+QbQCWY2p3jTwbWU512QvdqGI/RCng6300Vz8R4Bek6/1c43cSMR/45mYutZgpXHpkfURV3kLkf1TkYTj/lz/fcbtIZCCuSnFHWD0mpVuoNS8ApIi8yMMxHU/yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113812; c=relaxed/simple;
	bh=AVxkrwkHL5lUg31Gwfm5H8RybsTzZpoeo+3+40Mj9Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmWqFv4Kynw0gZzrBRZR4H31IAQY7HLitMFINU7wFztQ1nt25AM2uqvLYDu8nvsg78dwgGwDFok0EN7zbft5j/BizYjKw4xrmttq52530C/4rZvF7L2t2UCwqv4fw5fKia7HHVkOC7/ggW3Pr5NpAbtzuPAV2PAJqSx02oTcTeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsClVpCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsClVpCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EDFC4CEE7;
	Tue,  8 Apr 2025 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113812;
	bh=AVxkrwkHL5lUg31Gwfm5H8RybsTzZpoeo+3+40Mj9Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsClVpCQXCJ5r/SGaSR0WBam2lkurUPoCqTHCHe4XeK6QySRJSNSja16pzf++3hKh
	 YOVgUlSfXMrWZ4hl2VUnQQOgMVTmZAHLTrRF6fo0mg+PmunV5Lp6B5jeL439ygv6E+
	 V1pfOsTRgaWrdiDp5nuFdoQN8AFvwns1hPlcKH+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>
Subject: [PATCH 5.4 006/154] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Tue,  8 Apr 2025 12:49:07 +0200
Message-ID: <20250408104815.498867069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit ea62dd1383913b5999f3d16ae99d411f41b528d4 upstream.

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, as this is the only
member needed from the 'net' structure, but that would increase the size
of this fix, to use '*data' everywhere 'net->sctp.sctp_hmac_alg' is
used.

Fixes: 3c68198e7511 ("sctp: Make hmac algorithm selection for cookie generation dynamic")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-4-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -326,7 +326,8 @@ static int proc_sctp_do_hmac_alg(struct
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.sctp_hmac_alg);
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


