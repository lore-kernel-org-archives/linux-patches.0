Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B253617592;
	Tue, 30 Apr 2024 11:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475902; cv=none; b=PY/2lKx1XEqSTM1TvDK6IPu+BqqjYdy77GYZhpIeKOdmOdZTlyFbcLT2dvdeiX4ZCRE2DYhzYZ5TpOGn49vxwztXlHyLpBUKZSjkY60n2N8WphTFxVYlwG4xF4SJ9HwVbneCvzQi38VFHbbVyGnklJrLOknCUG7xbt+CfapDrwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475902; c=relaxed/simple;
	bh=KH23l98jTTixspcED7nrmHIhg9wuFhfm2qHFiqe88kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOM/zoX5oPq1X49wK9Y4is7XYZ8xn/HIV4vhSb/P88+JlI74jEzY3scUs7cqKL9DXcRTJMQhLAuLI9D+wuqyfSx2nJy4eMBaZrprihlRvq/JL0YBCOkHwfOACnpdd/v+E6qEEM9bUQmAqs2jkV5uWSnRzdsOPTqxwVFLb70n8DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuaIuD0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuaIuD0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0086CC2BBFC;
	Tue, 30 Apr 2024 11:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475902;
	bh=KH23l98jTTixspcED7nrmHIhg9wuFhfm2qHFiqe88kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuaIuD0byIwrqaNRAYOybQ5V3a+pxVTx148FbWtXRbasucK8MBCB/yiN7pTX6JXTF
	 y5VbOolpRJFsXG+EV47MvvLEu/cxs1m6RzaZkYMtJZEhj4j9mrzIDdYBDrPOgqA70z
	 pq44tCSzjw6YDblqFfHbiipAICVdvd1EfWW41ac4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 53/80] Bluetooth: Fix type of len in {l2cap,sco}_sock_getsockopt_old()
Date: Tue, 30 Apr 2024 12:40:25 +0200
Message-ID: <20240430103044.983868104@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 9bf4e919ccad613b3596eebf1ff37b05b6405307 upstream.

After an innocuous optimization change in LLVM main (19.0.0), x86_64
allmodconfig (which enables CONFIG_KCSAN / -fsanitize=thread) fails to
build due to the checks in check_copy_size():

  In file included from net/bluetooth/sco.c:27:
  In file included from include/linux/module.h:13:
  In file included from include/linux/stat.h:19:
  In file included from include/linux/time.h:60:
  In file included from include/linux/time32.h:13:
  In file included from include/linux/timex.h:67:
  In file included from arch/x86/include/asm/timex.h:6:
  In file included from arch/x86/include/asm/tsc.h:10:
  In file included from arch/x86/include/asm/msr.h:15:
  In file included from include/linux/percpu.h:7:
  In file included from include/linux/smp.h:118:
  include/linux/thread_info.h:244:4: error: call to '__bad_copy_from'
  declared with 'error' attribute: copy source size is too small
    244 |                         __bad_copy_from();
        |                         ^

The same exact error occurs in l2cap_sock.c. The copy_to_user()
statements that are failing come from l2cap_sock_getsockopt_old() and
sco_sock_getsockopt_old(). This does not occur with GCC with or without
KCSAN or Clang without KCSAN enabled.

len is defined as an 'int' because it is assigned from
'__user int *optlen'. However, it is clamped against the result of
sizeof(), which has a type of 'size_t' ('unsigned long' for 64-bit
platforms). This is done with min_t() because min() requires compatible
types, which results in both len and the result of sizeof() being casted
to 'unsigned int', meaning len changes signs and the result of sizeof()
is truncated. From there, len is passed to copy_to_user(), which has a
third parameter type of 'unsigned long', so it is widened and changes
signs again. This excessive casting in combination with the KCSAN
instrumentation causes LLVM to fail to eliminate the __bad_copy_from()
call, failing the build.

The official recommendation from LLVM developers is to consistently use
long types for all size variables to avoid the unnecessary casting in
the first place. Change the type of len to size_t in both
l2cap_sock_getsockopt_old() and sco_sock_getsockopt_old(). This clears
up the error while allowing min_t() to be replaced with min(), resulting
in simpler code with no casts and fewer implicit conversions. While len
is a different type than optlen now, it should result in no functional
change because the result of sizeof() will clamp all values of optlen in
the same manner as before.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2007
Link: https://github.com/llvm/llvm-project/issues/85647
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    7 ++++---
 net/bluetooth/sco.c        |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -456,7 +456,8 @@ static int l2cap_sock_getsockopt_old(str
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct l2cap_options opts;
 	struct l2cap_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -503,7 +504,7 @@ static int l2cap_sock_getsockopt_old(str
 
 		BT_DBG("mode 0x%2.2x", chan->mode);
 
-		len = min_t(unsigned int, len, sizeof(opts));
+		len = min(len, sizeof(opts));
 		if (copy_to_user(optval, (char *) &opts, len))
 			err = -EFAULT;
 
@@ -553,7 +554,7 @@ static int l2cap_sock_getsockopt_old(str
 		cinfo.hci_handle = chan->conn->hcon->handle;
 		memcpy(cinfo.dev_class, chan->conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *) &cinfo, len))
 			err = -EFAULT;
 
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -904,7 +904,8 @@ static int sco_sock_getsockopt_old(struc
 	struct sock *sk = sock->sk;
 	struct sco_options opts;
 	struct sco_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 
 	BT_DBG("sk %p", sk);
 
@@ -926,7 +927,7 @@ static int sco_sock_getsockopt_old(struc
 
 		BT_DBG("mtu %u", opts.mtu);
 
-		len = min_t(unsigned int, len, sizeof(opts));
+		len = min(len, sizeof(opts));
 		if (copy_to_user(optval, (char *)&opts, len))
 			err = -EFAULT;
 
@@ -944,7 +945,7 @@ static int sco_sock_getsockopt_old(struc
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *)&cinfo, len))
 			err = -EFAULT;
 


