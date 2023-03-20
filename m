Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3233F1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791BEC4339B;
	Mon, 20 Mar 2023 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324249;
	bh=bVEXnSf0Uyl7uKZ594mmBHNQSc6leXvNeKII+HAVxiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APOTBIy0MmjnKKGsbM3b1Cc0A9+8P9cj6IXdAuJDbVrARFyRhvUROTe9mMYrBPQoy
	 OlX2ayyJ+vWjDOLqXq0KHwKQCiDZ9Ac3uz5mnZallc2gyAZhuD32qVRQjChCN/uPk7
	 S6rN5VX6rIcfyMWDpxOjQwLjsVTrgHMoLLpc2hqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	HeungJun
Subject: [PATCH 4.14 19/30] media: m5mols: fix off-by-one loop termination error
Date: Mon, 20 Mar 2023 15:54:43 +0100
Message-Id: <20230320145420.940955681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit efbcbb12ee99f750c9f25c873b55ad774871de2a ]

The __find_restype() function loops over the m5mols_default_ffmt[]
array, and the termination condition ends up being wrong: instead of
stopping when the iterator becomes the size of the array it traverses,
it stops after it has already overshot the array.

Now, in practice this doesn't likely matter, because the code will
always find the entry it looks for, and will thus return early and never
hit that last extra iteration.

But it turns out that clang will unroll the loop fully, because it has
only two iterations (well, three due to the off-by-one bug), and then
clang will end up just giving up in the middle of the loop unrolling
when it notices that the code walks past the end of the array.

And that made 'objtool' very unhappy indeed, because the generated code
just falls off the edge of the universe, and ends up falling through to
the next function, causing this warning:

   drivers/media/i2c/m5mols/m5mols.o: warning: objtool: m5mols_set_fmt() falls through to next function m5mols_get_frame_desc()

Fix the loop ending condition.

Reported-by: Jens Axboe <axboe@kernel.dk>
Analyzed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Analyzed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/linux-block/CAHk-=wgTSdKYbmB1JYM5vmHMcD9J9UZr0mn7BOYM_LudrP+Xvw@mail.gmail.com/
Fixes: bc125106f8af ("[media] Add support for M-5MOLS 8 Mega Pixel camera ISP")
Cc: HeungJun, Kim <riverful.kim@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 9015ebc843b4e..e86fb73dbf6ab 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -482,7 +482,7 @@ static enum m5mols_restype __find_restype(u32 code)
 	do {
 		if (code == m5mols_default_ffmt[type].code)
 			return type;
-	} while (type++ != SIZE_DEFAULT_FFMT);
+	} while (++type != SIZE_DEFAULT_FFMT);
 
 	return 0;
 }
-- 
2.39.2



