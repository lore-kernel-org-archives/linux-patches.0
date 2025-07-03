Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A1B2EE299;
	Thu,  3 Jul 2025 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554880; cv=none; b=fWaADs2uDYxGJ1V76i4+O/UNRIl5z4/YufIlwNScYuiqwDSHHnCuQNBk1s1igVE5g5W1iGaIbKe7K3D06gT0fC+iW/SbNSXsCbhjG8o4+UrDicLSvnGzyyPbtWvwqdhum6nbGheBLgFJZTtuteZAFM137gJSwndt7nFlT2HhXT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554880; c=relaxed/simple;
	bh=d/vzMHPA8xL1hOVTWGeJF3ePmhv/rioNzSEy53VTx8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbaF9YsFo8zb8iuuLRk83nyNn8KHu9D6VCEumxZ9qeDS1NRWAjmoCQ724Lay5QNY7QheXEosHyoioInqQByzOJUE6OQu7JAi6dV8LC/QhEXh0A4WvqiRY5WkvEq+7bYdDDnuUy1pzpPPlKvGWd7v3cKqbgBGA7Q4DPSN4dh6Puo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqMfdyZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqMfdyZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4353DC4CEE3;
	Thu,  3 Jul 2025 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554879;
	bh=d/vzMHPA8xL1hOVTWGeJF3ePmhv/rioNzSEy53VTx8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqMfdyZDkKf5m242dy5Y+m/SGLyp3jjA1/jsX5JSynYzlUEWvQRAqfaOJSI40a7Zb
	 I2ZqXFk4WV0h9dT+jMoCt5inf5MJGnriG4l/4R0Vjuy8NapmcuISTlO8wAVMi5IiSk
	 oU9n0IzjhtEUOhnPkK3gtcZ26B/YvJGgep3ufFLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Jeff Layton <jlayton@kernel.org>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 108/263] scripts/gdb: fix dentry_name() lookup
Date: Thu,  3 Jul 2025 16:40:28 +0200
Message-ID: <20250703144008.668404043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 79300ac805b672a84b64d80d4cbc374d83411599 upstream.

The "d_iname" member was replaced with "d_shortname.string" in the commit
referenced in the Fixes tag.  This prevented the GDB script "lx-mount"
command to properly function:

(gdb) lx-mounts
      mount          super_block     devname pathname fstype options
0xff11000002d21180 0xff11000002d24800 rootfs / rootfs rw 0 0
0xff11000002e18a80 0xff11000003713000 /dev/root / ext4 rw,relatime 0 0
Python Exception <class 'gdb.error'>: There is no member named d_iname.
Error occurred in Python: There is no member named d_iname.

Link: https://lkml.kernel.org/r/20250619225105.320729-1-florian.fainelli@broadcom.com
Fixes: 58cf9c383c5c ("dcache: back inline names with a struct-wrapped array of unsigned long")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/vfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/vfs.py b/scripts/gdb/linux/vfs.py
index c77b9ce75f6d..b5fbb18ccb77 100644
--- a/scripts/gdb/linux/vfs.py
+++ b/scripts/gdb/linux/vfs.py
@@ -22,7 +22,7 @@ def dentry_name(d):
     if parent == d or parent == 0:
         return ""
     p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_iname'].string()
+    return p + d['d_shortname']['string'].string()
 
 class DentryName(gdb.Function):
     """Return string of the full path of a dentry.
-- 
2.50.0



