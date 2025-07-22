Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941E22E36E8;
	Tue, 22 Jul 2025 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192946; cv=none; b=Sz7amNe9TZqMptZpGH0O/zYjfrEqQ67Ae94AhR9V/CkoTjVtHv8sBXZliNYXcPw7P9H5vW7pdQ05yaJqsFQA6QPdBDkPjKByEChWupW0GbKdFBBABdl7UoDIEarZEE8IgkeSLcE2IawfYK/OM+jzZuEM2sZLzydrCm/WtQnIdVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192946; c=relaxed/simple;
	bh=8R8fsfAiB35JVv/KUlNn4w8yaSmlxWThbl9sAywA5V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGXLCF/iZicasjzolfr6SWxI5t/ebaWykxL6reGvx6/R1Rf1t7wMcQu5Y4CCzUtYktsvXV4Ptnb7pnisAwfqbpit01hXyoATflwX2u01RSJ1+7WryVwOqs35dsGbSaIfAWTtObE5NrICa31OUZeYppWPeSmXcbcKg6lbjdDoSvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SE4hXHJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SE4hXHJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02132C4CEEB;
	Tue, 22 Jul 2025 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192946;
	bh=8R8fsfAiB35JVv/KUlNn4w8yaSmlxWThbl9sAywA5V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SE4hXHJhgJ1uenghWTLK2/0E8FeA7o6MutW12MXBkzwYvdkJqbJReLXjVIifetNLP
	 k6sJh1ujbICRFZDAg16zSoRvpjYk5j41iYwKkbW4EtQBnXw8mHG+DyrQJpo1nMD2JS
	 KylFihPp/c7J+rtk1hwSdGtMVXwNTJX5dvmdOCMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Burri <markus.burri@mt.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 072/158] iio: backend: fix out-of-bound write
Date: Tue, 22 Jul 2025 15:44:16 +0200
Message-ID: <20250722134343.455020494@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Burri <markus.burri@mt.com>

commit da9374819eb3885636934c1006d450c3cb1a02ed upstream.

The buffer is set to 80 character. If a caller write more characters,
count is truncated to the max available space in "simple_write_to_buffer".
But afterwards a string terminator is written to the buffer at offset count
without boundary check. The zero termination is written OUT-OF-BOUND.

Add a check that the given buffer is smaller then the buffer to prevent.

Fixes: 035b4989211d ("iio: backend: make sure to NULL terminate stack buffer")
Signed-off-by: Markus Burri <markus.burri@mt.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250508130612.82270-2-markus.burri@mt.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-backend.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -155,11 +155,14 @@ static ssize_t iio_backend_debugfs_write
 	ssize_t rc;
 	int ret;
 
+	if (count >= sizeof(buf))
+		return -ENOSPC;
+
 	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf, count);
 	if (rc < 0)
 		return rc;
 
-	buf[count] = '\0';
+	buf[rc] = '\0';
 
 	ret = sscanf(buf, "%i %i", &back->cached_reg_addr, &val);
 


