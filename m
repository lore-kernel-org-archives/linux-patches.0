Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49676FB1;
	Tue,  5 Dec 2023 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgeXHlPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738A3C433C7;
	Tue,  5 Dec 2023 03:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747104;
	bh=rRNO5Kf/ZTueeQ0gGXs9PuYhXmE9f2dQ0a4OnBuQNvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgeXHlPxiCN08ICjg98qECV6i4S3tnUavpVSY+AdFttE7sTm0VUQyfIEY1d+XXCte
	 fyMFqRA6B2eek5HXF2VnCOMDYZwmtjD4A969t0iQsBDpeRPzVxjup/RvYECvxsElFh
	 jnRwrfghRyE4IvgY1+p7InpAP/7RU8DVvsbpK++0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/107] uapi: propagate __struct_group() attributes to the container union
Date: Tue,  5 Dec 2023 12:16:35 +0900
Message-ID: <20231205031535.169941786@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 4e86f32a13af1970d21be94f659cae56bbe487ee ]

Recently the kernel test robot has reported an ARM-specific BUILD_BUG_ON()
in an old and unmaintained wil6210 wireless driver. The problem comes from
the structure packing rules of old ARM ABI ('-mabi=apcs-gnu'). For example,
the following structure is packed to 18 bytes instead of 16:

struct poorly_packed {
        unsigned int a;
        unsigned int b;
        unsigned short c;
        union {
                struct {
                        unsigned short d;
                        unsigned int e;
                } __attribute__((packed));
                struct {
                        unsigned short d;
                        unsigned int e;
                } __attribute__((packed)) inner;
        };
} __attribute__((packed));

To fit it into 16 bytes, it's required to add packed attribute to the
container union as well:

struct poorly_packed {
        unsigned int a;
        unsigned int b;
        unsigned short c;
        union {
                struct {
                        unsigned short d;
                        unsigned int e;
                } __attribute__((packed));
                struct {
                        unsigned short d;
                        unsigned int e;
                } __attribute__((packed)) inner;
        } __attribute__((packed));
} __attribute__((packed));

Thanks to Andrew Pinski of GCC team for sorting the things out at
https://gcc.gnu.org/pipermail/gcc/2023-November/242888.html.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311150821.cI4yciFE-lkp@intel.com
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://lore.kernel.org/r/20231120110607.98956-1-dmantipov@yandex.ru
Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 7837ba4fe7289..dcd50fb2164a1 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -27,7 +27,7 @@
 	union { \
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
-	}
+	} ATTRS
 
 /**
  * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
-- 
2.42.0



