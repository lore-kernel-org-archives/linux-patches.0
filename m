Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89401FF5EF;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=SaHoRis9803W8bqXUbwLndLFcwELRhLbNhKGG6gIkVXY+AbuYbvAvKIcSrdtmBWQ4AlLZS1MZKehddgeEW05y35bz3Z+aOTdUc7xbx209VUPDBAhS1nlohVQQPA1A+GV5NN0JPg74bIo/BCCWgk9zi6AuiBuHCngdW96Ua1s5z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=vnnpomG+YXAQFsIDsRQmYC2J41959nMdsLJ0AiIvOK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKXEaNPBJSVwGllyuinhHQ60qvkp+nWBVNucooYFl7uO1wacWcQW+dD7JsIcAE1imKAntg5hb8Dd05I30zJ49Rg15zKrcZeSSSkc41RzGm7KxkSiaY+C6sZO2Myl1gTCuvxAzugjCihBsPqGVtO00tvjHGkasYzHRwyNN+Q7RCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hILaRTYM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hILaRTYM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rmr0mdJEelj4oy19Vz6V/3LQ9rOmZsbYuW/DdSgmS/A=; b=hILaRTYM6fAdW0sy6Z8lMgnByk
	piiXiKxtLxs8oTS8MxMMY7nhteVr1L/ZPwC7OdnW0Dbp6d5V/2qCFsamIbIo/gR9zpjNmoHSEvrtw
	1Bf867Rd6IwjG7kjlFecUKrWCEpznNmWc3xq/m7vpjHRqkL61dUvNgOnl7zWgHGzqz+loAlahSmof
	z6K543+VK1H+fZ7yqiyLn5lxCtDekjmLYmFa25xfnQUvUKnrd1PmLZNE3duxLQWZTzXmENAy2diS0
	EXxZeLQeQKygkNvVGyOjgJeUvcqTjuimwfZjDi4Lx5jXOeHNBb1PBJzAmQVEJvgqYtQBOEKjY8mxH
	RXLOhEdg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q89-3AyJ;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 2/6] block/032: make error messages clearer if mkfs or mount fails
Date: Wed, 12 Feb 2025 12:54:44 -0800
Message-ID: <20250212205448.2107005-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250212205448.2107005-1-mcgrof@kernel.org>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

If block/032 fails at mkfs we want to know why, so propagate
error messages. While at it, enhance the test to also propagate
the error return from mount and remove the odd sleep for a udevadm
settle as that's the only thing I can think of we need to wait for
here.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tests/block/032 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/block/032 b/tests/block/032
index 8975879660d7..fc6d1a51dcad 100755
--- a/tests/block/032
+++ b/tests/block/032
@@ -25,10 +25,10 @@ test() {
 	fi
 
 	mkdir -p "${TMPDIR}/mnt"
-	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" > /dev/null 2>&1
+	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> $FULL || return $?
 	echo 1 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/delete"
-	sleep 2
-	umount "${TMPDIR}/mnt"
+	udevadm settle
+	umount "${TMPDIR}/mnt" || return $?
 
 	_exit_scsi_debug
 
-- 
2.45.2

