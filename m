Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC1F25783C;
	Wed,  9 Sep 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963424; cv=none; b=OsIiF2qyggZCRyDo67uwQjK63TXEFPIW9f5/3glqtqapaZJ6TU0sLOnjD3myGTCu4Xjj+83D/+c9aKTT3DiCx9SePBa5bBcLdLkYg85Crqr7kr2ODkd4ZrmEU5ea62BIFX38F/nnytIrgqxx3q43UnVtcPFHLo9iCYyFwP2LDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963424; c=relaxed/simple;
	bh=4qzjd2iSG8g27ext//91ueEzPfAOGBu0Z/kvq8iR1gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsUqtZ/6A2LYNWahtPv2KmTzgyEw7O3FyW62tsV/G051AviFFLgCGRvO/E8Lz5AuxFBujc+rR7uRYGxwQwuNXVLD7izl4LFnXKdxImnItyBp4oPVFSzgweL0nY4nRJlWRIQg6yTU68tLZEJcatzI7o3S2wxC0JqOEf5+e/rebRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWZdg7tC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWZdg7tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56151F00A3A;
	Wed,  9 Sep 2026 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963423;
	bh=zh78yMcgNQhHjb6XVmv9YTkYZ7aV/HKDcOCf4a3pWF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWZdg7tC/1jSv2uagVthvqRwvwfrcUVDe6RS+DFZ80cIDMnD9bk6arnisMmwgNjFm
	 W3veR0rLMhBiK5wGNCgWdRO0cczlBSSBt1UzvkARwy/sqt8QqHh0MflyKw2xLVnNYO
	 t8PRl5bqnZi38k/I0epDDqN6E1vzew2NPh2h7rWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Lim <foxieflakey@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 037/583] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
Date: Wed,  9 Sep 2026 15:35:22 +0200
Message-ID: <20260909134239.201301501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Lim <foxieflakey@gmail.com>

commit f025ca73decda1f895a4b80b961d3bc88825298a upstream.

During move_pages() operation, when move_pages_ptes() returns EAGAIN, the
error code is not cleared even after we processed it.  This leads to a
successful retry but then the same pages are retried again due to the
stale error code.  This time move fails because pages are already moved,
loop is terminated and move_pages() reports a failure.  Clear the error
code once we processes EAGAIN.

Link: https://lore.kernel.org/e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com
Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Assisted-by: ChatGPT:GPT-5.6-Luna
Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1956,8 +1956,10 @@ ssize_t move_pages(struct userfaultfd_ct
 		}
 
 		if (err) {
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
+				err = 0;
 				continue;
+			}
 			break;
 		}
 


