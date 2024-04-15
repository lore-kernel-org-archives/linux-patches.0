Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7857BAF9;
	Mon, 15 Apr 2024 14:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191356; cv=none; b=dtBhgTVpK31vsrHKv1FQ+U+KORjjG4Wa19q6duUeSXPDvdy271MRXpawLXzqRSI2thUp+olpZ518nyJzl2r8LeP3VlYRlJnGFsN9nkoGQRR9il63Yk2za3TRluF/rwA8/NQYwu9KggQkA0QTV70+vhdxY5zXWiV54V3Ykwli+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191356; c=relaxed/simple;
	bh=EckqB4RaE3Huc5/l3CV/lxsyi1i58RIdhjQEW9sx8JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KldRScB+trjk32HMiRqzFPr3UZV2H1rKz8z5jUbjHi318DB1Y855EAa3MNr/u9LnMWvRRSv5/MgE4TyvvsTroM4ZlwKz2XjZFO4/f+wk+3mLVtaayXaMCe2doCtSqxtN8qu9AxeDfZ8LjNs5Qsi67hXpa02Bg3eZztpq8LeEpw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TK1W4YEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TK1W4YEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40016C113CC;
	Mon, 15 Apr 2024 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191356;
	bh=EckqB4RaE3Huc5/l3CV/lxsyi1i58RIdhjQEW9sx8JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TK1W4YEdBdjG/jV+NbROSOf1ZTTQQTV2g4I6STqa47qhy1/QuLh/wXxqkww3iQZPr
	 /IxJw6IKbRiN9jvb+vla98TUvJ8D6RCFFo7s8SSpoYU2Vv6HEKAJquG96sPpEK2nty
	 r8QdK5LeCF7lecJFvr2+Bmfe6MZuIOJcMCVlGjuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.8 115/172] fs/proc: Skip bootloader comment if no embedded kernel parameters
Date: Mon, 15 Apr 2024 16:20:14 +0200
Message-ID: <20240415142003.885448821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit c722cea208789d9e2660992bcd05fb9fac3adb56 upstream.

If the "bootconfig" kernel command-line argument was specified or if
the kernel was built with CONFIG_BOOT_CONFIG_FORCE, but if there are
no embedded kernel parameter, omit the "# Parameters from bootloader:"
comment from the /proc/bootconfig file.  This will cause automation
to fall back to the /proc/cmdline file, which will be identical to the
comment in this no-embedded-kernel-parameters case.

Link: https://lore.kernel.org/all/20240409044358.1156477-2-paulmck@kernel.org/

Fixes: 8b8ce6c75430 ("fs/proc: remove redundant comments from /proc/bootconfig")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/bootconfig.c       |    2 +-
 include/linux/bootconfig.h |    1 +
 init/main.c                |    5 +++++
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/proc/bootconfig.c
+++ b/fs/proc/bootconfig.c
@@ -63,7 +63,7 @@ static int __init copy_xbc_key_value_lis
 			dst += ret;
 		}
 	}
-	if (ret >= 0 && boot_command_line[0]) {
+	if (cmdline_has_extra_options() && ret >= 0 && boot_command_line[0]) {
 		ret = snprintf(dst, rest(dst, end), "# Parameters from bootloader:\n# %s\n",
 			       boot_command_line);
 		if (ret > 0)
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -10,6 +10,7 @@
 #ifdef __KERNEL__
 #include <linux/kernel.h>
 #include <linux/types.h>
+bool __init cmdline_has_extra_options(void);
 #else /* !__KERNEL__ */
 /*
  * NOTE: This is only for tools/bootconfig, because tools/bootconfig will
--- a/init/main.c
+++ b/init/main.c
@@ -485,6 +485,11 @@ static int __init warn_bootconfig(char *
 
 early_param("bootconfig", warn_bootconfig);
 
+bool __init cmdline_has_extra_options(void)
+{
+	return extra_command_line || extra_init_args;
+}
+
 /* Change NUL term back to "=", to make "param" the whole string. */
 static void __init repair_env_string(char *param, char *val)
 {


