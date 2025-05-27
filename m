Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D2928033F;
	Tue, 27 May 2025 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368199; cv=none; b=O/zCd+4gGbRhRAYdxE4TZgYQcSKaym9HPQcjrF8XFEDVeMjIcM9yCugMNhUk5Q/pQA+amwEGpjrX2ZSCP05yk6LMasX+KrsKMSMDvruvkBgDdvZji9qbZ+fXALcmgi78v+GU8gEwER4JQ5lMqeAZH+5exiKXTXcN9ld4aObrUI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368199; c=relaxed/simple;
	bh=K6eQWgcvxyYKecMj74UmrFvfQoPksh6pW7NSBvbSOrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6AyxvmfVWlfOGl0DAB6Ti/DwyqZHqtlmAhejvcv98Px+cr/pJtahwbqsezJjtWpkemsMaHOl9r5/LooT5Plh9/VQuLeRxoAu1yPwYpjGYq/N7hE3sI5HXJg08rD65s4gsePINWrexkkdBYXxq76wgelxHEFbsHLBvK+zga6UJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDFRcxQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDFRcxQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C99C4CEEA;
	Tue, 27 May 2025 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368199;
	bh=K6eQWgcvxyYKecMj74UmrFvfQoPksh6pW7NSBvbSOrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDFRcxQpASruQkANqlV3dyoves7+ihROWe47hv2H967/Q3gR5bJ8hsK/OpHErj4UX
	 P6o5oy4c0XhMxKNU2c4xFBqPuw+jQW3bHmJNZkL16eP36AtvvmEluKENvgGp5lUKJ0
	 anFVD/5Ys+5NBVSXtgi3of/JVTepgsUEU6EE9iZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 630/783] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
Date: Tue, 27 May 2025 18:27:07 +0200
Message-ID: <20250527162538.802201586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e8d2d287e26d9bd9114cf258a123a6b70812442e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 2cf2c567f8931..75127b6c161f0 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -552,6 +552,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}
-- 
2.39.5



