Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244872DEA7E;
	Fri, 21 Nov 2025 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731454; cv=none; b=GmNdoYyDV5S8cCAkvrU+Qs4NvqD4xXk7w8YEJHi5qbUpQjS0Uzzh6w/eFXS7a54qvaoN4Am4zyJk6SzLmqyBD285+RMw+XgQNfb68pO5LrSLCuIcAs+gDLpWRD1wMGJkb+h8qnsrJj5SxMgVPk3rS81D0YmzFjxlqM6swX40k5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731454; c=relaxed/simple;
	bh=7rJp4aogbdKe+q2ROCvQwVQTRANguRyS9kHIkiRVn+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6nLC4kMGgJa9Ks8E7Qg+BTt2QYMsx7DtBjmeXOHrxDvAe4negPWfWusZ+Bdlt/GNAkhUuCwr+nnQHYNo2gJRBNge9syc2/OqqbnXtdYE+IQMkl8fCeJyNa7ri++/8g+GJHDcPo3IkisaYWUsEYJAzTx4P2VS9H9Zmb8Pb95Hd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dwdjai9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dwdjai9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42725C4CEF1;
	Fri, 21 Nov 2025 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731453;
	bh=7rJp4aogbdKe+q2ROCvQwVQTRANguRyS9kHIkiRVn+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Dwdjai92WKKBwsIeBq9bO8tUDrUHw1wKSgozhzKnAnrCFPh1XtPkJnJQQQmfsRKj
	 EM+l+hVNk44L9E+6g9ktElW5SVAROqgctzlJjmqyrc7PgJFKfTourpbrHTDsh3Zdfn
	 DJsG5jhAcnzwl6oZ+8AQen0U0NsPkokyAc3ONXcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 213/247] PM: hibernate: Use atomic64_t for compressed_size variable
Date: Fri, 21 Nov 2025 14:12:40 +0100
Message-ID: <20251121130202.373982527@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 66ededc694f1d06a71ca35a3c8e3689e9b85b3ce upstream.

`compressed_size` can overflow, showing nonsensical values.

Change from `atomic_t` to `atomic64_t` to prevent overflow.

Fixes: a06c6f5d3cc9 ("PM: hibernate: Move to crypto APIs for LZO compression")
Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/linux-pm/20251105180506.137448-1-safinaskar@gmail.com/
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Askar Safin <safinaskar@gmail.com>
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
Link: https://patch.msgid.link/20251106045158.3198061-3-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -635,7 +635,7 @@ struct cmp_data {
 };
 
 /* Indicates the image size after compression */
-static atomic_t compressed_size = ATOMIC_INIT(0);
+static atomic64_t compressed_size = ATOMIC_INIT(0);
 
 /*
  * Compression function that runs in its own thread.
@@ -664,7 +664,7 @@ static int compress_threadfn(void *data)
 		d->ret = crypto_acomp_compress(d->cr);
 		d->cmp_len = d->cr->dlen;
 
-		atomic_set(&compressed_size, atomic_read(&compressed_size) + d->cmp_len);
+		atomic64_add(d->cmp_len, &compressed_size);
 		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
@@ -696,7 +696,7 @@ static int save_compressed_image(struct
 
 	hib_init_batch(&hb);
 
-	atomic_set(&compressed_size, 0);
+	atomic64_set(&compressed_size, 0);
 
 	/*
 	 * We'll limit the number of threads for compression to limit memory
@@ -879,8 +879,8 @@ out_finish:
 		ret = err2;
 	if (!ret) {
 		swsusp_show_speed(start, stop, nr_to_write, "Wrote");
-		pr_info("Image size after compression: %d kbytes\n",
-			(atomic_read(&compressed_size) / 1024));
+		pr_info("Image size after compression: %lld kbytes\n",
+			(atomic64_read(&compressed_size) / 1024));
 		pr_info("Image saving done\n");
 	} else {
 		pr_err("Image saving failed: %d\n", ret);


