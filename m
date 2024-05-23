Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C014A4C1;
	Thu, 23 May 2024 13:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470274; cv=none; b=Ygoq96kndy7NWSAXsQ480RpWvcDA4yR1wsXhVyvryXXvfAaVkkNpAeU1DeMataSYqhh6xhoZS3X0mxy11ShFNK323P4S1kVZM2w7seiaCwSFQAyA8pG5jHIWGsxZ22CDSKhEPkyLK8zGDdgG6fcVlvCumo7SOFTyG+mo9S118Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470274; c=relaxed/simple;
	bh=le9/UAp6QD0l6YJ5c7wb1qMb3Mm8XeGdue04mozS0hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cp7KB+4+hPLj27+pDb7KpOT5Jt+587F7pROQaxWWTPFQqoEmFLCbHswdA/YLDs0FAB2rbfPjE7rIQtk+c3Cv12iqAvPdLTO+xf3itOTt7e8x+Uqk9fCDSYfYEMKV20AoQT84BaGyQw10aoHcGI8oNHs+fcRh5Csqgwc3nssPj+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9lIsPnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9lIsPnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEDBC2BD10;
	Thu, 23 May 2024 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470274;
	bh=le9/UAp6QD0l6YJ5c7wb1qMb3Mm8XeGdue04mozS0hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9lIsPnDajfs7KCwfAvy2vaTe2DAzy84/iFZj8KtTZnj4ix9LJu9QFI3wvIhL520s
	 wGL11x92W0dMQo8k7oxM2OYoVnHTB9rIipTV/e1afP86vAe9idEkD8oEPNAQBXaWYP
	 SuW+b6Z75su746JoPBc1dDM8IFmsfSAE09Xq6/dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Chris Hyser <chris.hyser@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.9 20/25] admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET
Date: Thu, 23 May 2024 15:13:05 +0200
Message-ID: <20240523130331.144428352@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 8af2d1ab78f2342f8c4c3740ca02d86f0ebfac5a upstream.

sched_core_share_pid() copies the cookie to userspace with
put_user(id, (u64 __user *)uaddr), expecting 64 bits of space.
The "unsigned long" datatype that is documented in core-scheduling.rst
however is only 32 bits large on 32 bit architectures.

Document "unsigned long long" as the correct data type that is always
64bits large.

This matches what the selftest cs_prctl_test.c has been doing all along.

Fixes: 0159bb020ca9 ("Documentation: Add usecases, design and interface for core scheduling")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/util-linux/df7a25a0-7923-4f8b-a527-5e6f0064074d@t-8ch.de/
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Chris Hyser <chris.hyser@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20240423-core-scheduling-cookie-v1-1-5753a35f8dfc@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/core-scheduling.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/core-scheduling.rst
+++ b/Documentation/admin-guide/hw-vuln/core-scheduling.rst
@@ -67,8 +67,8 @@ arg4:
     will be performed for all tasks in the task group of ``pid``.
 
 arg5:
-    userspace pointer to an unsigned long for storing the cookie returned by
-    ``PR_SCHED_CORE_GET`` command. Should be 0 for all other commands.
+    userspace pointer to an unsigned long long for storing the cookie returned
+    by ``PR_SCHED_CORE_GET`` command. Should be 0 for all other commands.
 
 In order for a process to push a cookie to, or pull a cookie from a process, it
 is required to have the ptrace access mode: `PTRACE_MODE_READ_REALCREDS` to the


