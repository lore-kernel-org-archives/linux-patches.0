Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368015DBA5;
	Mon, 29 Jan 2024 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548433; cv=none; b=FDglrXuRLqSP+qhEoy+AeJwplFLHTFdk/hHnCvDYANsfRYz6mc067NisOgEPIy1M+RpB2vDLYMDc046aFb0GxYNtka2Ti1P77l/ePGwd7KQXKhUL6A9PyRQ0cMJBf0vKIM+MN7la2Ab6jCPkgJRz7mX8YuUUwij9zoeFmKYp8Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548433; c=relaxed/simple;
	bh=rVNU7d49QV9+RqxP7Jo2ANEqSaan+Rbfan1fP0nOk9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKIBkK4CbLSRQ3C9ZKfRu9r76l4ErDmfMR+OHVGg2eBICKJbyN7xmLsf0KV/Vziqyw3fHlykiToWVXa6yCK/dB5UwYGWMi2RstWsL/YP4sFL1hsVHE+r2n8oeLXXlxKJe0w4HsnWONYruKkVLPHTlE7a/ZXPQAsWJhTmKB0g4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EwTfdxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EwTfdxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE86C43390;
	Mon, 29 Jan 2024 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548433;
	bh=rVNU7d49QV9+RqxP7Jo2ANEqSaan+Rbfan1fP0nOk9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EwTfdxoditFYDSm6nTgZ0nNkHcn3EnRqSV7iewRiPHVQa8a9puxSGyglgnZipM5w
	 QOwkGH/cKiuv9bNi6iPxVXgcbD0+TepTL4sNd2QAZbTrt3kWn+GrmfQ6WqNnN59gG3
	 ZIAI3JcuXUyhwsHDr6oNBNuSd9RJo8UUZ7gJo0Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 036/331] btrfs: sysfs: validate scrub_speed_max value
Date: Mon, 29 Jan 2024 09:01:40 -0800
Message-ID: <20240129170015.996717259@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -1760,6 +1760,10 @@ static ssize_t btrfs_devinfo_scrub_speed
 	unsigned long long limit;
 
 	limit = memparse(buf, &endptr);
+	/* There could be trailing '\n', also catch any typos after the value. */
+	endptr = skip_spaces(endptr);
+	if (*endptr != 0)
+		return -EINVAL;
 	WRITE_ONCE(device->scrub_speed_max, limit);
 	return len;
 }


