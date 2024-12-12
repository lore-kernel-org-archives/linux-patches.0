Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053B2210CA;
	Thu, 12 Dec 2024 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018044; cv=none; b=isyjIss5BQ+lowRu4avVU6HeNgF5kfnyKW2GRerbqOqGPy0NcUqUTpl7pEVRiJGsU6SKfJVWu1RdK9WGGxfQUG1yw4WTouTlY1pow1giDkxbYAWbMmCVV+b+eKB3Lmuf62ZoxrBBEaU6wswhh2qsz677CsrBMRyQdvGCvbOFdtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018044; c=relaxed/simple;
	bh=a5TOyy/qPZcv/VmSHNRTRfgQoSZis9r7btMF6VbBNpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXPs/K46e7xWLek895sxH7Qi5cMvqVnVtDckntCdK/bagYTj7/h7SWEaLLsF7pWsjnxzG4FKIhZDCjjziSt9j6iurqNVoPK69KG3Ds1SwpKlNMmRVrdJosmexIJgsJg3dHYOMVqKkYD6r9TI842NSz4mKYIXynq3s6PWuiNkYDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpdNy9VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpdNy9VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448EBC4CECE;
	Thu, 12 Dec 2024 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018043;
	bh=a5TOyy/qPZcv/VmSHNRTRfgQoSZis9r7btMF6VbBNpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpdNy9VMxyg5qJryblz0JbVp9qQcMIY7z+okzA882VkLSc9oaM+RpMfNEe5Aqmz5n
	 6FtTg6rt1BMaWpiKnl86T/MHOG4dg/fgFQNLL/5IY8qYAlSmq3Pkys//98HS5h/jZX
	 ET67Komv2ZcmIq6fr/FZYOzbzlSo/hknnqviiDE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 181/356] lib: stackinit: hide never-taken branch from compiler
Date: Thu, 12 Dec 2024 15:58:20 +0100
Message-ID: <20241212144251.781855100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 5c3793604f91123bf49bc792ce697a0bef4c173c upstream.

The never-taken branch leads to an invalid bounds condition, which is by
design. To avoid the unwanted warning from the compiler, hide the
variable from the optimizer.

../lib/stackinit_kunit.c: In function 'do_nothing_u16_zero':
../lib/stackinit_kunit.c:51:49: error: array subscript 1 is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Werror=array-bounds=]
   51 | #define DO_NOTHING_RETURN_SCALAR(ptr)           *(ptr)
      |                                                 ^~~~~~
../lib/stackinit_kunit.c:219:24: note: in expansion of macro 'DO_NOTHING_RETURN_SCALAR'
  219 |                 return DO_NOTHING_RETURN_ ## which(ptr + 1);    \
      |                        ^~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241117113813.work.735-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/stackinit_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackinit_kunit.c
+++ b/lib/stackinit_kunit.c
@@ -199,6 +199,7 @@ static noinline void test_ ## name (stru
 static noinline DO_NOTHING_TYPE_ ## which(var_type)		\
 do_nothing_ ## name(var_type *ptr)				\
 {								\
+	OPTIMIZER_HIDE_VAR(ptr);				\
 	/* Will always be true, but compiler doesn't know. */	\
 	if ((unsigned long)ptr > 0x2)				\
 		return DO_NOTHING_RETURN_ ## which(ptr);	\


