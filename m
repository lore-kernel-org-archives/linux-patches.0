Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE01DE4C4;
	Wed,  7 May 2025 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643467; cv=none; b=TuPr4rA7PFB6R7kyPztDEsRQQTyLXn6794VYiwWVD549MCAdWpapVTfk+zjTCHkMOLqWSgLVmaIMaYF1J7Xz5jdxq8md/rQfcPOHWdKa3IJrOlHkyssGauaDU4dc9UTB+oaQfhxM2Kqs17LSqDVdJWI//J9dPKzc2J0/oclueQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643467; c=relaxed/simple;
	bh=sdaIUi8FHgJTmAimLvfYoK6zeOU9s14gd02R1AfnCS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFLgQab1zkFO1AXXfGgaGFBWP9Lq6RP6jum5TW97kzwEdaDtrx36VT4HMGaEI46m7bL2gasxI8N29ifaar6+u70ESMPAlceD6J6AhTZyk9zD4dPBhswn4Ed4JY3aSSQZepiNW99ao9AZIj6obD8LWFCzJiR2aql6ZqIn3SUFv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pph16I5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pph16I5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90F8C4CEE2;
	Wed,  7 May 2025 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643467;
	bh=sdaIUi8FHgJTmAimLvfYoK6zeOU9s14gd02R1AfnCS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pph16I5t9FS0OwY7apZYXcRUSNjOU/v3PTMYCw/pckkcYoCYpKgm+U3xxR09nL17Y
	 k+ywnW6W0CyAA83jyOUsRimFUpxJ0ZGXBzVaj6SCvH+lGBLMYx9x+P8PLWQmTE1wfR
	 H0EsolQxudULnWy3M+sn3u2xGoFnHb3tDmb2Xn9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 14/97] dm-integrity: fix a warning on invalid table line
Date: Wed,  7 May 2025 20:38:49 +0200
Message-ID: <20250507183807.564119288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a533c3e4246c29d502a7e0fba0e86d80a906b04 upstream.

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4637,7 +4637,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


