Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A41B6FB1;
	Tue,  5 Dec 2023 03:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i26BjfPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36EFC433C8;
	Tue,  5 Dec 2023 03:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747199;
	bh=NojsTa3hzw5AxRBOCIkiF0/lzb9itN6tMhz4yrblD5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i26BjfPkW0urcWNQ6X1tC2n7JyghKXtmzbwunkqBcpY8n6zM1BfNXPH8PWh0ZhoxE
	 fibtJrrnZWn3sqifv2+fUJn3VmdftGRFhGE9RpDV0hVBFOZ/bBN6wB5/NxXbCAy8YS
	 7LU8WrBZz/nGCVF2CK8d3/EVQ05pPsJz3y/qs0OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/107] selftests/net: fix a char signedness issue
Date: Tue,  5 Dec 2023 12:16:37 +0900
Message-ID: <20231205031535.287764230@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 7b29828c5af6841bdeb9fafa32fdfeff7ab9c407 ]

Signedness of char is signed on x86_64, but unsigned on arm64.

Fix the warning building cmsg_sender.c on signed platforms or
forced with -fsigned-char:

    msg_sender.c:455:12:
    error: implicit conversion from 'int' to 'char'
    changes value from 128 to -128
    [-Werror,-Wconstant-conversion]
        buf[0] = ICMPV6_ECHO_REQUEST;

constant ICMPV6_ECHO_REQUEST is 128.

Link: https://lwn.net/Articles/911914
Fixes: de17e305a810 ("selftests: net: cmsg_sender: support icmp and raw sockets")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20231124171645.1011043-3-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 24b21b15ed3fb..6ff3e732f449f 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -416,9 +416,9 @@ int main(int argc, char *argv[])
 {
 	struct addrinfo hints, *ai;
 	struct iovec iov[1];
+	unsigned char *buf;
 	struct msghdr msg;
 	char cbuf[1024];
-	char *buf;
 	int err;
 	int fd;
 
-- 
2.42.0



