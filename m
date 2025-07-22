Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA4E2EA743;
	Tue, 22 Jul 2025 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193415; cv=none; b=YhWE5xfzUbqjnH70U+U+JL/VG4rBh3ukQMdPTyy9KAXsmO73U3Bqx/QdevMcpiN4kdWBunHtPCN2HfqmNnZWA6eR8PY4HUNh9gerQIDS4Vl4JDhwdwqu6CfP7AhXuNWUIVtV8NDTGbOHmIAMzthDZNZWNvSOp1FtKFsWAtkPc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193415; c=relaxed/simple;
	bh=9KLuY+hr7SUBYFR8idqO71jNiEPOZnaA9Zlf4IhOfnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKwvLlQU43PxNFucQkBCRKQVz9ycZOaGjS04bZtqlBIDcY71WEYsTmM9qExhHJqQEuPsn7mpN67oG6fOiAzfzqXcQNUwHAGkkUErvtufMNtawuZyRaUGYR3bPUNCCqYQsxxydtbmwatWaIPVreO8Q3eme0VQveN7FNaarZNO7O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkUr6KNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkUr6KNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4EBC4CEF1;
	Tue, 22 Jul 2025 14:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193415;
	bh=9KLuY+hr7SUBYFR8idqO71jNiEPOZnaA9Zlf4IhOfnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkUr6KNoaWCfKSTeT4Zb9bKHOqakTZB44WtTYNKyMA6qSq5z1BDBXyx8f+dXls2jZ
	 uTVIIoo2J/WgULAgkKWjvoPjbpui3y6meI6SnLT8hiVHi2SMtmYM8s56Z1fA0h9zbp
	 R/PLR2GrltcmSWNMhgsXTXN1yByjBXyAaLQ6uXZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Burri <markus.burri@mt.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 086/187] iio: backend: fix out-of-bound write
Date: Tue, 22 Jul 2025 15:44:16 +0200
Message-ID: <20250722134348.925957102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


