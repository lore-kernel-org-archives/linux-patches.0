Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D5F1BDEC;
	Wed,  3 Jan 2024 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqzbvaxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F208C433C7;
	Wed,  3 Jan 2024 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301867;
	bh=QXz11bEnxNyVeiQXZLZAinQ1qFikTXlLh28Pl1qQ6rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqzbvaxktNTbqeXPC55klwQmWR8J9ckHFGVDo1i0uhgbLx7iUP5SXlj38Mbl9DNbd
	 beEkTLRxiAnTz8vtdnYgj++Gva2BNablfMAPUpViqzucyKHul6/4x3Qt/Tlxfn3NPj
	 +8TmBjxmTK+LAb14ceaKwFVFAR1y+wWUCYZ+tevk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Hangyu Hua <hbh25y@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>
Subject: [PATCH 5.10 51/75] 9p/net: fix possible memory leak in p9_check_errors()
Date: Wed,  3 Jan 2024 17:55:32 +0100
Message-ID: <20240103164850.838030735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

commit ce07087964208eee2ca2f9ee4a98f8b5d9027fe6 upstream.

When p9pdu_readf() is called with "s?d" attribute, it allocates a pointer
that will store a string. But when p9pdu_readf() fails while handling "d"
then this pointer will not be freed in p9_check_errors().

Fixes: 51a87c552dfd ("9p: rework client code to use new protocol support functions")
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Message-ID: <20231027030302.11927-1-hbh25y@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218235
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -520,11 +520,14 @@ static int p9_check_errors(struct p9_cli
 		return 0;
 
 	if (!p9_is_proto_dotl(c)) {
-		char *ename;
+		char *ename = NULL;
+
 		err = p9pdu_readf(&req->rc, c->proto_version, "s?d",
 				  &ename, &ecode);
-		if (err)
+		if (err) {
+			kfree(ename);
 			goto out_err;
+		}
 
 		if (p9_is_proto_dotu(c) && ecode < 512)
 			err = -ecode;


