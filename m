Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56A2356DB;
	Mon,  2 Jun 2025 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877512; cv=none; b=Ua+pnr9ulCHcaeWuqUOIr+r8YN38jH5eAmgiJLzGmUBQ0Yv4yNHRLgRgoz7WDiz1OfBOQPenybhIhJvQj8zoNYHRc8JUXE9LFOcH6/9mtBLyRGwfklMwDFM5+p3oQ7JtQQfXUvTYVCAa9PRDjdLc6t1yoqJf7OYg3IUBiSdiYkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877512; c=relaxed/simple;
	bh=HrLE0deh4e7SdE1LIHx5vT39nnNVNUbf9MneQ00Thcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQXouAflBgEQpFy5DogLChV4H+v7radup0+iqZ6E4ob1xTIhwQ2V2jwKhHGKKjRF3eV4LmdG0YYXMK9B+ZIqWQwnk8EBHQz+A3dgRscm9D2nejwSTm98ET3BxS8E6SbinShAD4QHS1TfWvRETvqry31lKcHlTlgROl+Z3xK/5qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdKzSNAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdKzSNAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CF5C4CEEB;
	Mon,  2 Jun 2025 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877511;
	bh=HrLE0deh4e7SdE1LIHx5vT39nnNVNUbf9MneQ00Thcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdKzSNAQtZRP3TBBNCqHfJ/2Fj+QAYbwrgl6FaV7nlk2vxhx23yEYEo/jJyICxKkW
	 XosNw/yr/3PrvyhfAQpYXRQ55vZ3ig7/VYettRLzdYRM6qNfIXwZkqdVCGGRb8iHv4
	 l7G7plfDpm3X7tRermk/Gpxw413FCx+7nGLgqyQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 273/325] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
Date: Mon,  2 Jun 2025 15:49:09 +0200
Message-ID: <20250602134330.857876058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit e8d2d287e26d9bd9114cf258a123a6b70812442e upstream.

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/i3c/master/svc-i3c-master.c:596:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
    596 |         default:
        |         ^
  drivers/i3c/master/svc-i3c-master.c:596:2: note: insert 'break;' to avoid fall-through
    596 |         default:
        |         ^
        |         break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: 0430bf9bc1ac ("i3c: master: svc: Fix missing STOP for master request")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250319-i3c-fix-clang-fallthrough-v1-1-d8e02be1ef5c@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -496,6 +496,7 @@ static void svc_i3c_master_ibi_work(stru
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}


