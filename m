Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC5C469855;
	Wed, 23 Sep 2026 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172623; cv=none; b=c1/Xxbzmce9A9AOIfTL2sEeXTYgw4CtyLDxYtBy0qb+mOKtCT49mXpdR901UOQCmRlu0UyqEAIK+cFoXMJtYtXijoBPddT84D76m0cgzjW8U3jwFKl76W8KMv5VBLOkC0yLInybzoIb0N7eDYt+cSB2KDejpfqsRIzT6K0OWKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172623; c=relaxed/simple;
	bh=Pc7UE8cTIObZ8GYxMn2baflbbdrmvbrDc5p/KUYMHJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vz21cdy4+NCShiolJrp2d7Cw2XWLCc9Wpz3hspOTGT4QDpsAx7mF5x8Xwc+U3IdknMP21x3+FG7KaiUXKnb6Ezl4wNmQliFMV+PH1p4pEYkqcN73yh6iOri1tU9B3bI2h2LMPnV+NUqbkKewYv63oB89aqjAt5P1NdyPp2UGa94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckm5GumT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckm5GumT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923EF1F000FF;
	Wed, 23 Sep 2026 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172622;
	bh=YA0WzV+BnOEmo5w51g2czcoO8Gemp8k6F1PSqcMZrwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckm5GumTDvBvfUYgEJsckKWls16wdcobu8j5VTkM/1KImhl7vBZlBW3529YOAjO1i
	 U4hvBUPoJtBh27rBxwvY1oEvqjCxgEFENKQdb27UD41nxvl+ztmmuvVPZ9wkCeyvRU
	 94chW9TdTduOmbW8QiYenBuoMCoWrMcM/7QNRNqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/398] selftests/landlock: Add missing connect(minimal AF_UNSPEC) test
Date: Wed, 23 Sep 2026 16:01:18 +0200
Message-ID: <20260923140643.559967608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit 6685201ebfacff0c889bcd569181fa6e8af5575e ]

connect_variant(unspec_any0) is called twice. Both calls end
up in connect_variant_addrlen() with an address length of
get_addrlen(minimal=false).
However, the connect() syscall and its variants (e.g.
iouring/compat) accept much shorter addresses of 4 bytes
and that behaviour was not tested.

Replace one of these calls with one using a minimal address
length (just a bare sa_family=AF_UNSPEC field with no actual
address). Also add a call using a truncated address for good
measure.

Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20251027190726.626244-3-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/net_test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index c725c08414a10..8f3a780d354b7 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -964,7 +964,19 @@ TEST_F(protocol, connect_unspec)
 			EXPECT_EQ(0, close(ruleset_fd));
 		}
 
-		ret = connect_variant(connect_fd, &self->unspec_any0);
+		/* Try to re-disconnect with a truncated address struct. */
+		EXPECT_EQ(-EINVAL,
+			  connect_variant_addrlen(
+				  connect_fd, &self->unspec_any0,
+				  get_addrlen(&self->unspec_any0, true) - 1));
+
+		/*
+		 * Re-disconnect, with a minimal sockaddr struct (just a
+		 * bare af_family=AF_UNSPEC field).
+		 */
+		ret = connect_variant_addrlen(connect_fd, &self->unspec_any0,
+					      get_addrlen(&self->unspec_any0,
+							  true));
 		if (self->srv0.protocol.domain == AF_UNIX &&
 		    self->srv0.protocol.type == SOCK_STREAM) {
 			EXPECT_EQ(-EINVAL, ret);
-- 
2.53.0



