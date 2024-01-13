Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282021846;
	Sat, 13 Jan 2024 09:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyX2j/Io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99059C433F1;
	Sat, 13 Jan 2024 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139994;
	bh=LNjdVDZqClTL+iEuzyVXFM7HdstHJOoe4jK8flIaw70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyX2j/IoZDbLZVeVni3x39iyC8BpAuNFNG4SCfuQKc30utwAqQUnA0Nx1dlCNMaFE
	 wqfLakWWqW5KJ8VPiYnfTj/r/6+qYBPduGPHXCadFC28a1H3mFhJ5Ikx9S20kWWmQz
	 oPwo9SLpr9qN6g2N3ojajD5lAWXOxFW2rlnCQsmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/59] net: Implement missing getsockopt(SO_TIMESTAMPING_NEW)
Date: Sat, 13 Jan 2024 10:49:49 +0100
Message-ID: <20240113094209.871593031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>

[ Upstream commit 7f6ca95d16b96567ce4cf458a2790ff17fa620c3 ]

Commit 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW") added the new
socket option SO_TIMESTAMPING_NEW. Setting the option is handled in
sk_setsockopt(), querying it was not handled in sk_getsockopt(), though.

Following remarks on an earlier submission of this patch, keep the old
behavior of getsockopt(SO_TIMESTAMPING_OLD) which returns the active
flags even if they actually have been set through SO_TIMESTAMPING_NEW.

The new getsockopt(SO_TIMESTAMPING_NEW) is stricter, returning flags
only if they have been set through the same option.

Fixes: 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW")
Link: https://lore.kernel.org/lkml/20230703175048.151683-1-jthinz@mailbox.tu-berlin.de/
Link: https://lore.kernel.org/netdev/0d7cddc9-03fa-43db-a579-14f3e822615b@app.fastmail.com/
Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 662cd6d54ac70..ef29106af6046 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1534,9 +1534,16 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TIMESTAMPING_OLD:
+	case SO_TIMESTAMPING_NEW:
 		lv = sizeof(v.timestamping);
-		v.timestamping.flags = sk->sk_tsflags;
-		v.timestamping.bind_phc = sk->sk_bind_phc;
+		/* For the later-added case SO_TIMESTAMPING_NEW: Be strict about only
+		 * returning the flags when they were set through the same option.
+		 * Don't change the beviour for the old case SO_TIMESTAMPING_OLD.
+		 */
+		if (optname == SO_TIMESTAMPING_OLD || sock_flag(sk, SOCK_TSTAMP_NEW)) {
+			v.timestamping.flags = sk->sk_tsflags;
+			v.timestamping.bind_phc = sk->sk_bind_phc;
+		}
 		break;
 
 	case SO_RCVTIMEO_OLD:
-- 
2.43.0



