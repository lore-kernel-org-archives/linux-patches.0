Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB02F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAF6C433EF;
	Wed, 12 Apr 2023 08:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289608;
	bh=bOadoILlgOOloG3mTQUCnISegTY8fET2gxLwAADQfPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08OBrYNmPm3hkSmCqzR03k9GdO64Mroe6QCAh+bgbO3xY8Q5U2YJGQOqvm9EAEiRq
	 9NviNrBFmja5ACc4bkPRQu77CztxuENPcH70U053/mZknzm8eiHzJWzIqZ7uSSeOKJ
	 bvZvLfr0BrCDwNrhaceLuFFtB+RM6xz5kJ/5FSUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	syzbot+502859d610c661e56545@syzkaller.appspotmail.com
Subject: [PATCH 6.2 165/173] maple_tree: fix mas_prev() and mas_find() state handling
Date: Wed, 12 Apr 2023 10:34:51 +0200
Message-Id: <20230412082844.816593786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 17dc622c7b0f94e49bed030726df4db12ecaa6b5 upstream.

When mas_prev() does not find anything, set the state to MAS_NONE.

Handle the MAS_NONE in mas_find() like a MAS_START.

Link: https://lkml.kernel.org/r/20230120162650.984577-7-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+502859d610c661e56545@syzkaller.appspotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4849,7 +4849,7 @@ static inline void *mas_prev_entry(struc
 
 	if (mas->index < min) {
 		mas->index = mas->last = min;
-		mas_pause(mas);
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 retry:
@@ -5911,6 +5911,7 @@ void *mas_prev(struct ma_state *mas, uns
 	if (!mas->index) {
 		/* Nothing comes before 0 */
 		mas->last = 0;
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 
@@ -6001,6 +6002,9 @@ void *mas_find(struct ma_state *mas, uns
 		mas->index = ++mas->last;
 	}
 
+	if (unlikely(mas_is_none(mas)))
+		mas->node = MAS_START;
+
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
 		void *entry;


