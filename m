Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8839FE8;
	Fri, 24 Nov 2023 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSszEdPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF3BC433C8;
	Fri, 24 Nov 2023 18:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848925;
	bh=4ek0P6ClWcE0ZllCjwC/LAe36g6JgCTeLFpNK9ktgtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSszEdPPBiEqaTNDeKOwR0uU9sAv23ylfHMlR6llIx1OXLgnos8BgXt2NlfXbbhaw
	 9yT30H/7F4d+Rky8P266EJWBkTndc+FEfA0gHjAZaiR7CFVHR1LFR0+lf+uzS/Rhh4
	 71mcGVCQ68Xu/ew7q7gaYLL7YOVW9VBPM4y5qyZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 37/57] PM: hibernate: Clean up sync_read handling in snapshot_write_next()
Date: Fri, 24 Nov 2023 17:51:01 +0000
Message-ID: <20231124171931.675920357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Geffon <bgeffon@google.com>

commit d08970df1980476f27936e24d452550f3e9e92e1 upstream.

In snapshot_write_next(), sync_read is set and unset in three different
spots unnecessiarly. As a result there is a subtle bug where the first
page after the meta data has been loaded unconditionally sets sync_read
to 0. If this first PFN was actually a highmem page, then the returned
buffer will be the global "buffer," and the page needs to be loaded
synchronously.

That is, I'm not sure we can always assume the following to be safe:

	handle->buffer = get_buffer(&orig_bm, &ca);
	handle->sync_read = 0;

Because get_buffer() can call get_highmem_page_buffer() which can
return 'buffer'.

The easiest way to address this is just set sync_read before
snapshot_write_next() returns if handle->buffer == buffer.

Signed-off-by: Brian Geffon <bgeffon@google.com>
Fixes: 8357376d3df2 ("[PATCH] swsusp: Improve handling of highmem")
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/snapshot.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2592,8 +2592,6 @@ int snapshot_write_next(struct snapshot_
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
 
-	handle->sync_read = 1;
-
 	if (!handle->cur) {
 		if (!buffer)
 			/* This makes the buffer be freed by swsusp_free() */
@@ -2634,7 +2632,6 @@ int snapshot_write_next(struct snapshot_
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
 			handle->buffer = get_buffer(&orig_bm, &ca);
-			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
 		}
@@ -2646,9 +2643,8 @@ int snapshot_write_next(struct snapshot_
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
-		if (handle->buffer != buffer)
-			handle->sync_read = 0;
 	}
+	handle->sync_read = (handle->buffer == buffer);
 	handle->cur++;
 	return PAGE_SIZE;
 }


