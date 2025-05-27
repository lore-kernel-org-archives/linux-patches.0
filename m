Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7111E89C;
	Tue, 27 May 2025 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366214; cv=none; b=N67IbwcmpKchZ/pZLVACuqk7Z16LmZkJodNKEyeBe2wP/z0ZamLimPP/WriO8rw8eYazZoM0x4t9iRIczfdzXTfDGWpNBuL13j6iRJ4xRVK3SQzfEwmvzKCledSRJYlYuewnHXRbSYOyuI6Jg4u4H9exnlw2O5LYuH7JcwrxHAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366214; c=relaxed/simple;
	bh=R0FQGwcS+EQ4dliEssZCAij0s1q4bhYvrABbS02wUUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pz6JW5fgHyGeLNed6pdjwUeFcwbAmzFk3rZZC+Zi0C5xP5t4nvYq2cS6K/Gr3OD2USJMubFepyQ8fxYSKWibPWHMz9ra6kuPpoACU/2ovvXOJegmtDoNX2ge7XCpvAwqlgt6mpFibuasHulQBpVC5UXPn9175hGjn9Ckl+7pOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPgnkWhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPgnkWhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D06C4CEE9;
	Tue, 27 May 2025 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366214;
	bh=R0FQGwcS+EQ4dliEssZCAij0s1q4bhYvrABbS02wUUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPgnkWhhut+bCEP2Ol1EJNkCpe1xnSuq1cUG0BrYNC8jrwxggnBA1LmDNcpJ6KalH
	 0d7Yen8viy07xSa361z1cr2Ksl6PbEan4AdYdGepkzKmMXWr/F2i3OI6sFFeKKDsbX
	 ho+7sVEsZ7Ajo/JknCs5JgBSiOChIbrc3VG6uuPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 624/626] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
Date: Tue, 27 May 2025 18:28:37 +0200
Message-ID: <20250527162510.353156039@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -512,6 +512,7 @@ static void svc_i3c_master_ibi_work(stru
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}


