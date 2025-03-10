Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67A22D023;
	Mon, 10 Mar 2025 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629327; cv=none; b=u04HZQQqRYFFpRW1LsQcqoAjY01sX7P+OsYY3eO4tyHlWHz57cbNT0mc1oj2jKmYcfsNs8BHzSgaZJPFO81NEI8BHyyAUya897YeTeRLXl98sRJhQQiZ3EafaETWx5joZ9sHbpDFxZfpDQuTAW0u7uDieoz/MCjkzjDUMBSD49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629327; c=relaxed/simple;
	bh=6+IvV7UC+poDaNJ2LBTjXPO4jPlMxDtODu9fMh1DPeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/OHE5EhfHk2XZBjye9SEkiGtTUE4VdW3SCa7+wUXX32XJfP5bhgSTlwWac0zGrCxFsK3lrCkVRLmDJR7V4DdgzhaFWqWV9VLSTk0co2MC5290Bw6JD5tz/Xs4rA0ldBvrRLkNnbmLcuOhpW5dOAhgKljdmJdbTtCV9A9Kleak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqzmq3Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqzmq3Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B336C4CEE5;
	Mon, 10 Mar 2025 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629327;
	bh=6+IvV7UC+poDaNJ2LBTjXPO4jPlMxDtODu9fMh1DPeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqzmq3EvAM1Pus7VZ2ajgIbTA7FPycxg64/ix04rLWS0mPiPx7SPO2HXGd6E2Zlxp
	 VFRSoLDWiB+IEiZb+at+MPF3uWaeToYMCgANxhFxKeHHQPzpEEXiGaV8bcxACBRFVu
	 VZf9qZ0z9s0j+nGnojlAPZlLVBNtFX6shKbHD9W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.15 257/620] binfmt_flat: Fix integer overflow bug on 32 bit systems
Date: Mon, 10 Mar 2025 18:01:43 +0100
Message-ID: <20250310170555.770109804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 55cf2f4b945f6a6416cc2524ba740b83cc9af25a upstream.

Most of these sizes and counts are capped at 256MB so the math doesn't
result in an integer overflow.  The "relocs" count needs to be checked
as well.  Otherwise on 32bit systems the calculation of "full_data"
could be wrong.

	full_data = data_len + relocs * sizeof(unsigned long);

Fixes: c995ee28d29d ("binfmt_flat: prevent kernel dammage from corrupted executable headers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/5be17f6c-5338-43be-91ef-650153b975cb@stanley.mountain
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -542,7 +542,7 @@ static int load_flat_file(struct linux_b
 	 * 28 bits (256 MB) is way more than reasonable in this case.
 	 * If some top bits are set we have probable binary corruption.
 	*/
-	if ((text_len | data_len | bss_len | stack_len | full_data) >> 28) {
+	if ((text_len | data_len | bss_len | stack_len | relocs | full_data) >> 28) {
 		pr_err("bad header\n");
 		ret = -ENOEXEC;
 		goto err;


