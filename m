Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B7E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEADC433C9;
	Sun, 13 Aug 2023 21:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962333;
	bh=AlirPVlmGJEyWN4RLg7vt+by28P7HhhhV0Ip+hE5gB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfFglTso5WjsPTGwdcRDYZiV8+ID8UhcFiphlRpFzNUBRa2l2bSo6BczAfQN58m+u
	 opVlcq7BY8yC0LC2dQogyTIyAbUrV899Wgk7WYKCwtvxXWR7YC3AvNo8ImKqSobgC2
	 xiy493sUd4GHU6cF3NQqDSwRePsFjIg7O4oKZwSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Nikita Kravets <teackot@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>
Subject: [PATCH 6.4 198/206] platform/x86: msi-ec: Fix the build
Date: Sun, 13 Aug 2023 23:19:28 +0200
Message-ID: <20230813211730.679644327@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jean Delvare <jdelvare@suse.de>

commit 5a66d59b5ff537ddae84a1f175c3f8eb1140a562 upstream.

The msi-ec driver fails to build for me (gcc 7.5):

  CC [M]  drivers/platform/x86/msi-ec.o
drivers/platform/x86/msi-ec.c:72:6: error: initializer element is not constant
    { SM_ECO_NAME,     0xc2 },
      ^~~~~~~~~~~
drivers/platform/x86/msi-ec.c:72:6: note: (near initialization for ‘CONF0.shift_mode.modes[0].name’)
drivers/platform/x86/msi-ec.c:73:6: error: initializer element is not constant
    { SM_COMFORT_NAME, 0xc1 },
      ^~~~~~~~~~~~~~~
drivers/platform/x86/msi-ec.c:73:6: note: (near initialization for ‘CONF0.shift_mode.modes[1].name’)
drivers/platform/x86/msi-ec.c:74:6: error: initializer element is not constant
    { SM_SPORT_NAME,   0xc0 },
      ^~~~~~~~~~~~~
drivers/platform/x86/msi-ec.c:74:6: note: (near initialization for ‘CONF0.shift_mode.modes[2].name’)
(...)

Don't try to be smart, just use defines for the constant strings. The
compiler will recognize it's the same string and will store it only
once in the data section anyway.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Cc: stable@vger.kernel.org
Cc: Nikita Kravets <teackot@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Link: https://lore.kernel.org/r/20230805101010.54d49e91@endymion.delvare
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/msi-ec.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -27,15 +27,15 @@
 #include <linux/seq_file.h>
 #include <linux/string.h>
 
-static const char *const SM_ECO_NAME       = "eco";
-static const char *const SM_COMFORT_NAME   = "comfort";
-static const char *const SM_SPORT_NAME     = "sport";
-static const char *const SM_TURBO_NAME     = "turbo";
+#define SM_ECO_NAME		"eco"
+#define SM_COMFORT_NAME		"comfort"
+#define SM_SPORT_NAME		"sport"
+#define SM_TURBO_NAME		"turbo"
 
-static const char *const FM_AUTO_NAME     = "auto";
-static const char *const FM_SILENT_NAME   = "silent";
-static const char *const FM_BASIC_NAME    = "basic";
-static const char *const FM_ADVANCED_NAME = "advanced";
+#define FM_AUTO_NAME		"auto"
+#define FM_SILENT_NAME		"silent"
+#define FM_BASIC_NAME		"basic"
+#define FM_ADVANCED_NAME	"advanced"
 
 static const char * const ALLOWED_FW_0[] __initconst = {
 	"14C1EMS1.012",


