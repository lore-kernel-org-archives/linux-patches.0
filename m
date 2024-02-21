Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240DC78B4F;
	Wed, 21 Feb 2024 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521841; cv=none; b=bk78BdU88FG/5rdi9c3aHd6NjTKitC/by8qwpw+otfCOKcu8c62bdUeV1Rh/oeViiK0PklxfmEBdGgcLz9SU37zf6SZkXiwvtjSdgzTETu4m92Sjctj9UilLHoiJpgGzH7NZTjc10h0VavwD1oY003BEuwSAUNmsq2rGNNjm6i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521841; c=relaxed/simple;
	bh=qrO14WMjGzMguiq0Mqa3Stn9FIABrguiXY761+1a5+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeVxtyCJlFrNqISuf6boYSXn+E5lMzUp9nlZiUaijjBiC+hx5WOkqOpZthXOVVc5oGZzMd2cQeB5SPy6u9RvH/X2cLUnkrdrPLzxVrVcESpXhxC8v1qGK5upxtlarqIEhqToewgeD44X0XGb6KlNxweiFFkOpUDZi+YNBiFc8RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG5uOmEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG5uOmEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B65C433C7;
	Wed, 21 Feb 2024 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521841;
	bh=qrO14WMjGzMguiq0Mqa3Stn9FIABrguiXY761+1a5+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG5uOmEkMvOdrCW3Gq7Q4uIWHSl3tEgiZ1zvpLWTyip/E6kbO8BtV8S2fCseFgX3+
	 oiz0L5kqqIARQTZf//A+7IYgQ1gwUhUH0qpu5HUlD+p4Epsq6JxVOjih/GlY/O3mC3
	 rdnfLmILvyYurJm9cv4YcQrTKCUo7+XhuDrw1EVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 014/476] btrfs: sysfs: validate scrub_speed_max value
Date: Wed, 21 Feb 2024 14:01:05 +0100
Message-ID: <20240221130008.403824565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1523,6 +1523,10 @@ static ssize_t btrfs_devinfo_scrub_speed
 	unsigned long long limit;
 
 	limit = memparse(buf, &endptr);
+	/* There could be trailing '\n', also catch any typos after the value. */
+	endptr = skip_spaces(endptr);
+	if (*endptr != 0)
+		return -EINVAL;
 	WRITE_ONCE(device->scrub_speed_max, limit);
 	return len;
 }


