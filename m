Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1A6151CE1;
	Tue, 20 Feb 2024 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463428; cv=none; b=iikiYiQnwnriT2sedjYOz4Tudx8TvxujI9SBpYr3GGJp+azjxEn7FoItMqV+Hsfp8e+jjHGndkPgIX4vsHuGeFLsFjvanE3uO11onMABq6Zz31Qj/e/2GnhVFfrCHKRjSYX1q8c9RYFBvLgd3FJCSfyAhYPjF2WjiuskPZKkb6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463428; c=relaxed/simple;
	bh=Efn9U/b2/UiOm+K05LXMoV6Vglm1IG1SqkRNyOJ+MNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opxsIgbahHV17lUFlZAcjKq+u6B6bLI32/1JxBNfcTw48cS6rU1NGeaBMv/byVnu7802iNkDeYvbhzZqdKjjBucTCfsrW4wrQ/Dh4tCxZVp4D/CQNa2rWY9fXoiKSwYraARY8DXLwvQ99TqJ6IcRc3FbOVWdCR6J5WsKZTv/IjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb/yvmCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb/yvmCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC3AC433F1;
	Tue, 20 Feb 2024 21:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463427;
	bh=Efn9U/b2/UiOm+K05LXMoV6Vglm1IG1SqkRNyOJ+MNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jb/yvmCpRkbsbyaywuRSadTkG6fejoccF6kiVU3ImSHZ4mug92sUD8q8qRfzgm8Kc
	 xwW5GakEZX6HByQluTgqwoaGz/h32rl51HFwObj8WOY+Ge43EHOUU6TMwa1rhdQgs3
	 GjxEqKrBsVqBL2amRHOQFDBWHy6jw2E4AYutKtFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/331] net/handshake: Fix handshake_req_destroy_test1
Date: Tue, 20 Feb 2024 21:52:19 +0100
Message-ID: <20240220205638.323406311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4e1d71cabb19ec2586827adfc60d68689c68c194 ]

Recently, handshake_req_destroy_test1 started failing:

Expected handshake_req_destroy_test == req, but
    handshake_req_destroy_test == 0000000000000000
    req == 0000000060f99b40
not ok 11 req_destroy works

This is because "sock_release(sock)" was replaced with "fput(filp)"
to address a memory leak. Note that sock_release() is synchronous
but fput() usually delays the final close and clean-up.

The delay is not consequential in the other cases that were changed
but handshake_req_destroy_test1 is testing that handshake_req_cancel()
followed by closing the file actually does call the ->hp_destroy
method. Thus the PTR_EQ test at the end has to be sure that the
final close is complete before it checks the pointer.

We cannot use a completion here because if ->hp_destroy is never
called (ie, there is an API bug) then the test will hang.

Reported by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/netdev/ZcKDd1to4MPANCrn@tissot.1015granger.net/T/#mac5c6299f86799f1c71776f3a07f9c566c7c3c40
Fixes: 4a0f07d71b04 ("net/handshake: Fix memory leak in __sock_create() and sock_alloc_file()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/170724699027.91401.7839730697326806733.stgit@oracle-102.nfsv4bat.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/handshake-test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
index 16ed7bfd29e4..34fd1d9b2db8 100644
--- a/net/handshake/handshake-test.c
+++ b/net/handshake/handshake-test.c
@@ -471,7 +471,10 @@ static void handshake_req_destroy_test1(struct kunit *test)
 	handshake_req_cancel(sock->sk);
 
 	/* Act */
-	fput(filp);
+	/* Ensure the close/release/put process has run to
+	 * completion before checking the result.
+	 */
+	__fput_sync(filp);
 
 	/* Assert */
 	KUNIT_EXPECT_PTR_EQ(test, handshake_req_destroy_test, req);
-- 
2.43.0



