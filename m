Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69A7381A5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr+l04PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BBEC4E775;
	Wed, 15 Nov 2023 20:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081548;
	bh=t6DsEiyNoTxVpO/f+BpWwpbIibuOvdYsPNqWwmHxTd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr+l04POwvqvpuAm59nNdgCYQ6hvWBHmgW0/6kzfunCbvYb03Difj7lkS6D1YtNYU
	 ABrRKCuFCIVgkXjxuWLkHKaqbCPSDC00AxosmmvJZS93vaNAkLAxR9kk4O/ggKSzPa
	 V5IlUerHHM5e5YUEFLvAqfDI5fOvAkNwda200PE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Hangyu Hua <hbh25y@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/244] 9p/net: fix possible memory leak in p9_check_errors()
Date: Wed, 15 Nov 2023 15:36:26 -0500
Message-ID: <20231115203600.025230620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit ce07087964208eee2ca2f9ee4a98f8b5d9027fe6 ]

When p9pdu_readf() is called with "s?d" attribute, it allocates a pointer
that will store a string. But when p9pdu_readf() fails while handling "d"
then this pointer will not be freed in p9_check_errors().

Fixes: 51a87c552dfd ("9p: rework client code to use new protocol support functions")
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Message-ID: <20231027030302.11927-1-hbh25y@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index c4c1e44cd7ca3..9fdcaa956c008 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -520,12 +520,14 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 		return 0;
 
 	if (!p9_is_proto_dotl(c)) {
-		char *ename;
+		char *ename = NULL;
 
 		err = p9pdu_readf(&req->rc, c->proto_version, "s?d",
 				  &ename, &ecode);
-		if (err)
+		if (err) {
+			kfree(ename);
 			goto out_err;
+		}
 
 		if (p9_is_proto_dotu(c) && ecode < 512)
 			err = -ecode;
-- 
2.42.0



