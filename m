Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1F115B998;
	Thu, 28 May 2026 19:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998398; cv=none; b=EZp7JMDwCnORyXnApwgJZ/haCmfc1lIXbloV0o9xy5NJkeo3xMqHv1ve7VlI0T1HVQQpqO62alHAufpNhNbkZoJVB25hRoxRjkWZjEaAjaTk1WViLEvu90DodPC5HpfUhGDwnXU3mekdkpAFqlWUQnr4DoXR8+0NLkU769ly8YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998398; c=relaxed/simple;
	bh=zVPZZ3gnd5/iK8+Ryc5BeeafxjfncR8AUhj5BvMjPjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yoss6mFk8Vgwy5hY6fT5E3PNYY5G7nWivUv3w6t7DLU7dOgGU5oSDqrrJvdge5U1mCgVNKEBnKsZqML1p0FIVBTeZa+0h+67IRnUJ3wwAGVzkf34gG76NNxUJMFEVyqP4rPoaLZ17Wbrh6BckwpoFutctTdqA8+x4T/eTJQvLH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVZDoCDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVZDoCDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8221F1F000E9;
	Thu, 28 May 2026 19:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998397;
	bh=h6mEd+GXk76lOSursPFR71Z60oE+dOqpJx1b2ZR/QSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVZDoCDIGx2dv5vCrhnkM62BfcqDPdm//vPonlkB8EptFsCT5yhxZkCTqz+XOiNLU
	 IYu5XfsuSPV6dVBBQg/kGYwT3sbzOLz0ZoM1U9UwkdDgJPiuhcoBQ26ku4IKP4y9Vv
	 wWKqHXiDzGcAwC2gEdC6YM7uiaOJ9wNgulbf3KUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.0 122/461] s390/pai: Disable duplicate read of kernel PAI counter value
Date: Thu, 28 May 2026 21:44:11 +0200
Message-ID: <20260528194650.514239646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit 3fe7ecab1a0856aafe1026a35af1621a5c18d53f upstream.

The PAI crypto counter design allows for user space and kernel space
PAI counter increment recording. This is achieved by splitting the
recording page in half. The upper part of the 4KB page records user
space increments of PAI crypto counter and the lower half records
kernel space increments. The page itself looks like:

 lowcore ptr ---> ++++++++++++++++++++++++
                  |user space area       |
                  +----------------------+
                  |kernel space area     |
                  ++++++++++++++++++++++++

User space and kernel space entries are handled via a kernel_offset
value when wrting. For PAI crypto counters this offset is 2048 or
half of a page size.

For PAI NNPA counter design this distinction was not needed. There is
no user and kernel space part for the page pointed to by lowcore.
The set up is:

 lowcore ptr ---> ++++++++++++++++++++++++
                  |user + kernel space   |
                  |area                  |
                  |                      |
                  ++++++++++++++++++++++++

There is always only one counter value recorded and saved.

Depending on number of CPUs and machine load, the number of PAI NNPA
counter increment differs between counting (perf stat) and recording
(perf record). The number reported by sampling was double the number
shown by counting.

This was caused by a double read of the PAI NNPA values in function
pai_copy(). The first part of that function reads the kernel space part.
The offset into the kernel page part must be larger than zero.
The second part of that function reads the user space part, which
begins of offset zero. This works fine for PAI crypto counters.

It fails for PAI NNPA counters because the PMU device driver does
not support that feature and has a kernel_offset value of 0x0.
Executing both user and kernel space read out might end up reading
user space value twice.
For the PAI NNPA PMU prohibit the kernel space part read out.

Cc: stable@vger.kernel.org
Fixes: f12473541356 ("s390/pai_crypto: Rename paicrypt_copy() to pai_copy()")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_pai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_pai.c
+++ b/arch/s390/kernel/perf_pai.c
@@ -651,7 +651,7 @@ static void pai_have_sample(struct perf_
 	rawsize = pai_copy(cpump->save, cpump->area, pp,
 			   (unsigned long *)PAI_SAVE_AREA(event),
 			   event->attr.exclude_user,
-			   event->attr.exclude_kernel);
+			   !pp->kernel_offset ? true : event->attr.exclude_kernel);
 	if (rawsize)			/* No incremented counters */
 		pai_push_sample(rawsize, cpump, event);
 }


