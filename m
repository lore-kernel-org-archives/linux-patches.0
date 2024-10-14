Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9620EB;
	Mon, 14 Oct 2024 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916743; cv=none; b=Lj1z1a56ZIVHXKXW1pHoGvmoZfI1FoH8Iq16C764TssfYLiQ3u73SNtFJWp3NkwFuAMf2Egm4FdN/5s5CVych5KhWVu2gLdrMas4RwbvTB1DO7L6pzOJHBTkRAMNKfaAop7e7HEKuMrEteQUTan++MRs7ytKubYZO2x8dUUc83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916743; c=relaxed/simple;
	bh=kaH8vuRF9cBlQ8ea9M0kFH8gS+O/UVJrey1AKXii4rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW4Qw76Q8fNiQUlR9zcgPGUsWaeJPZ4alqldIPxcFXL1XULCTEgjtQNRwALp5AdVyRSt3bgWhGPYDKl9RiR0ECbu/Qj9HXxXLHP5EH9LLaLzDJgMZ1Zi+h1MB87ub52P6azGMswBOpbTXCQTybnwQimk9uyqGjPMOS/WnPdfBIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXru16yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXru16yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E80CC4CEC3;
	Mon, 14 Oct 2024 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916743;
	bh=kaH8vuRF9cBlQ8ea9M0kFH8gS+O/UVJrey1AKXii4rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXru16ytrdKSVLWLgJveFq7SIcZLwobgIVLKBGGpQzI6CXNfFe6L8fiEUfwbsjay5
	 1ptKmHKVxvYB979AX5c0xupq1KQ5JrAtyLhZTlqTfa2Rl3Tf9Hpp0rI19YL8rvz8QZ
	 cwUmaEfsxqW4F507xQnH1zbsHidRKaf3aMLHTpeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/213] zram: free secondary algorithms names
Date: Mon, 14 Oct 2024 16:19:19 +0200
Message-ID: <20241014141045.061193191@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 684826f8271ad97580b138b9ffd462005e470b99 ]

We need to kfree() secondary algorithms names when reset zram device that
had multi-streams, otherwise we leak memory.

[senozhatsky@chromium.org: kfree(NULL) is legal]
  Link: https://lkml.kernel.org/r/20240917013021.868769-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240911025600.3681789-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 06673c6ca2555..db729035fd6bf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1983,6 +1983,11 @@ static void zram_destroy_comps(struct zram *zram)
 		zcomp_destroy(comp);
 		zram->num_active_comps--;
 	}
+
+	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		kfree(zram->comp_algs[prio]);
+		zram->comp_algs[prio] = NULL;
+	}
 }
 
 static void zram_reset_device(struct zram *zram)
-- 
2.43.0



