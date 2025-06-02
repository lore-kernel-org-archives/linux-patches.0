Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C4E2222DA;
	Mon,  2 Jun 2025 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876548; cv=none; b=BfygLxF5MMZ7K6l3W63GVIiE5P823aU1ze2Q7xa0MleT/EXXAJtDtcxLRCEII3A5uSdwbCChnMsJqaB7sOe8AVA2u7Zi16fcjWhwwGabVu/wauyCiI+c8Ao561GSfKPkh35bQ7ZcA8d14bLl10PdyHV1IE31mMk4bzT6wNjl5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876548; c=relaxed/simple;
	bh=l1fmWtr/ewYtppCzFpgO6qkTWjeEu3rDmrn+9GD+W58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRUIxur8KcV4NC3yLPv1B3UMYakwUd4U25VFDg2sHu/GZAI9mCHbbHC1GXa9uTuSYRDcIKqfoO+dPbUSpx1dySa57kiD91RhNgGvhZm6EBS7yYnKzMvOsgFoGYdZbvQ3sFNgV6JvCvwL03dCBydD6uvdVlKIuLQw9NrOoTZYVIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTDPZvoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTDPZvoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067F3C4CEEE;
	Mon,  2 Jun 2025 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876548;
	bh=l1fmWtr/ewYtppCzFpgO6qkTWjeEu3rDmrn+9GD+W58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTDPZvoUz0MhJR2n9N2rnx1EH1ek1k/dJEg6IYaBLHuMxjD31YUCssd46JCNbipRj
	 fLTpcl+B4bxB3t4vris/qfs9hjcMGhABLHkiDBpKANi7HLTWVgGw835fskUG5ogX8n
	 ck+Z6vUgywQznrOA1gJ7Mh9pXr7FFuf8NlWiRDUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 186/207] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
Date: Mon,  2 Jun 2025 15:49:18 +0200
Message-ID: <20250602134306.041965487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -438,6 +438,7 @@ static void svc_i3c_master_ibi_work(stru
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}


