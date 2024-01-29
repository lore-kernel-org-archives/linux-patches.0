Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A689915957C;
	Mon, 29 Jan 2024 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548193; cv=none; b=Ybf7WMHi9mjcSuqD6Q8LXaQ6jNkd6VM+iCL47/mu4ip/PXLGlLu+JUAKUEiOj8dyJtmyRajNuABXH50tfLi6QAkqsaLpaSUyFP3mV9vVrWdGKyIEktuhmbbbKQk1fbamdryjCzaNbhr1rNcZKwhlUsIKY9AlL+5MUAixIq0f37w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548193; c=relaxed/simple;
	bh=eDau1d3lcbAgMs4ZoqC3KDrv7TPZ7KcANnke49llMks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH5lTm/YteT/qQY9UWyzk1JVeKCp0SWWKjYspdT7AR9q6+0QwzAOutbsudWPEceXV08N82195aK+sjiWPGftIbHypj9/a/ei/7C+wKF9O4OQnETtLdy3MQ99/gO0kg4ptPToCveuqTHidAesxfU/3wo9zO4VZurN3hlB2Yt3GZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SPzwN63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SPzwN63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F056C43390;
	Mon, 29 Jan 2024 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548193;
	bh=eDau1d3lcbAgMs4ZoqC3KDrv7TPZ7KcANnke49llMks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SPzwN63pYVq8e+AyjPctjlem2yugJQime4bqb6QnUjK5/ku+FpVA/cr8XA5JKB8T
	 yJ4u8TLomwEPhauDAHZOh5rpokliXermil0PuOvrr2Wo1CpWi07HOnn/61T2UxuF2r
	 Rto2JYXP5GmwDJlGpXxMdlnYUWvgGZYi2Hmra8Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 010/185] btrfs: sysfs: validate scrub_speed_max value
Date: Mon, 29 Jan 2024 09:03:30 -0800
Message-ID: <20240129165958.919828634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Disseldorp <ddiss@suse.de>

commit 2b0122aaa800b021e36027d7f29e206f87c761d6 upstream.

The value set as scrub_speed_max accepts size with suffixes
(k/m/g/t/p/e) but we should still validate it for trailing characters,
similar to what we do with chunk_size_store.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1704,6 +1704,10 @@ static ssize_t btrfs_devinfo_scrub_speed
 	unsigned long long limit;
 
 	limit = memparse(buf, &endptr);
+	/* There could be trailing '\n', also catch any typos after the value. */
+	endptr = skip_spaces(endptr);
+	if (*endptr != 0)
+		return -EINVAL;
 	WRITE_ONCE(device->scrub_speed_max, limit);
 	return len;
 }


