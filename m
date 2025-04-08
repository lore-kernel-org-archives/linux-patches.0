Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD54E266583;
	Tue,  8 Apr 2025 11:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110629; cv=none; b=HQ8O8CudodaKIPvPs2mIwvY6lj6g8I0J9UPhKx8M8yY60bP85ns/LBjkoElj8EO+vIpGGAAzNqsqIodxuykCfJuUaMKKqxj9xFntaHwUfBQv8y2Q42tAeXtQNmTbZi5JR44ctRSAkwIBg43FluSqbZocm2nltfpgIpcnOG4/j/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110629; c=relaxed/simple;
	bh=La3p62KhWZJdg2hx6NwdViw3FTqe1e+czG6Hy7qLViI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEiSK64FF5Qy+1OR6MaRHlSLIFcNkmJjiOaHQu0tuSiO3DMrnXEBEsKiCzZ7WJaVWIhm0rPnuIdJspd+C89qZjczMqLKRmqAqSbhcZ/YxmqhWiA+QkY3yqYI+XAxyYLWNQFIFOZhye1RKai+42oGF6lfLAhrRqJ0TPRD+zXg0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diAykTAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diAykTAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AAC4CEE7;
	Tue,  8 Apr 2025 11:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110629;
	bh=La3p62KhWZJdg2hx6NwdViw3FTqe1e+czG6Hy7qLViI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diAykTAum60YgvEuucZ2siXxvQELsKEgWtexB3wRS/luJblS8GPfiBe+v0dHOWk+y
	 Hn3qy2OxOuurlYzGfnyc6kqXmcoeKmZBD9BhmVPWjLou4dx3P2RLu7ztkQWNiWvhA1
	 HHPyF6uvVv7ljnsoRgdul6DU5nluJW1Pa1mAykAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 136/731] tools/rv: Keep user LDFLAGS in build
Date: Tue,  8 Apr 2025 12:40:33 +0200
Message-ID: <20250408104917.442675582@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit e82c78afa3d48f6512570e7d39258cd68e7bae0a ]

rv, unlike rtla and perf, drops LDFLAGS supplied by the user and honors
only EXTRA_LDFLAGS. This is inconsistent with both perf and rtla and
can lead to all kinds of unexpected behavior.

For example, on Fedora and RHEL, it causes rv to be build without
PIE, unlike the aforementioned perf and rtla:

$ file /usr/bin/{rv,rtla,perf}
/usr/bin/rv:   ELF 64-bit LSB executable, ...
/usr/bin/rtla: ELF 64-bit LSB pie executable, ...
/usr/bin/perf: ELF 64-bit LSB pie executable, ...

Keep both LDFLAGS and EXTRA_LDFLAGS for the build.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250304142228.767658-1-tglozar@redhat.com
Fixes: 012e4e77df73 ("tools/verification: Use tools/build makefiles on rv")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/Makefile.rv | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/rv/Makefile.rv b/tools/verification/rv/Makefile.rv
index 161baa29eb86c..2497fb96c83d2 100644
--- a/tools/verification/rv/Makefile.rv
+++ b/tools/verification/rv/Makefile.rv
@@ -27,7 +27,7 @@ endif
 
 INCLUDE		:= -Iinclude/
 CFLAGS		:= -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(WOPTS) $(EXTRA_CFLAGS) $(INCLUDE)
-LDFLAGS		:= -ggdb $(EXTRA_LDFLAGS)
+LDFLAGS		:= -ggdb $(LDFLAGS) $(EXTRA_LDFLAGS)
 
 INSTALL		:= install
 MKDIR		:= mkdir
-- 
2.39.5



