Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10236FE35;
	Mon,  8 Apr 2024 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583885; cv=none; b=Yg5ZABArVSX0c3KzCoxIp1p7zmYjQF8cNS7TinrkByLlmAwr2SHYOFE3Gsm8YjQKMh0Qpz3C/OYT1In/l1HKN5RyTUNWTD48mObIXnodJmoHZUZ+0g9GJ/mSXnndoq3qVDkPkGrdqxpQGtlBLpXWNPj0kEc1FrIggCUhPQegApg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583885; c=relaxed/simple;
	bh=N1v9wdxwv/7VhbxA9zgImmkDAZ7OuoUcs5OMcmnnADE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcX1EipHnFgdK7F+qdVWRnJqzoAX+WK53izvo+jfqUEWWbIu9gftmZNndFvua9a4bj8L23DypuJXOmBjka9H9HgMFyYh69Riompd+ZhKddp+3f8u7K2BDTCU2QMP1GiTRLJtirj8rE2+a5tyhSgHQDJbAZG/Uzi3UX5bi+akJVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lu7uy4+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lu7uy4+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFD0C433C7;
	Mon,  8 Apr 2024 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583885;
	bh=N1v9wdxwv/7VhbxA9zgImmkDAZ7OuoUcs5OMcmnnADE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lu7uy4+x3AWN1GFYNW7FpLqJRzsRpGncGxrC8QrzZJyxh8HB2IP36FSGLl2gRuGQ6
	 GsZaIUHVk/ZyUxYgqU4+3Bz+td2SmIk5SzDMNsTsRd0EMUBgScK0USwXDs5IBzC9oP
	 n1tHzsYZaDJJvgpa5JQEEfurjzYP518aAk4FlKKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.8 230/273] of: module: prevent NULL pointer dereference in vsnprintf()
Date: Mon,  8 Apr 2024 14:58:25 +0200
Message-ID: <20240408125316.568552761@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit a1aa5390cc912934fee76ce80af5f940452fa987 upstream.

In of_modalias(), we can get passed the str and len parameters which would
cause a kernel oops in vsnprintf() since it only allows passing a NULL ptr
when the length is also 0. Also, we need to filter out the negative values
of the len parameter as these will result in a really huge buffer since
snprintf() takes size_t parameter while ours is ssize_t...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1d211023-3923-685b-20f0-f3f90ea56e1f@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/module.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/of/module.c
+++ b/drivers/of/module.c
@@ -16,6 +16,14 @@ ssize_t of_modalias(const struct device_
 	ssize_t csize;
 	ssize_t tsize;
 
+	/*
+	 * Prevent a kernel oops in vsnprintf() -- it only allows passing a
+	 * NULL ptr when the length is also 0. Also filter out the negative
+	 * lengths...
+	 */
+	if ((len > 0 && !str) || len < 0)
+		return -EINVAL;
+
 	/* Name & Type */
 	/* %p eats all alphanum characters, so %c must be used here */
 	csize = snprintf(str, len, "of:N%pOFn%c%s", np, 'T',


