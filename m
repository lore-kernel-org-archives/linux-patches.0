Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8922689C;
	Sat, 25 Oct 2025 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408605; cv=none; b=LnIjSkOLTDTT56CZBzdvqAkwRZlWXE3w0HVZ+xSTcAtrQRm1qDrTvdUM9NtyJqQF6TWQ7lWnJRmg0UqzA/Wpfl5aO6UBgYnQ+/wRzsWJOYMo9QFeMZD+Tj2b1qqrdeu6hcnZROx74kqq2JAqbteBE7SQKoKV8SYoh8UkLFssSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408605; c=relaxed/simple;
	bh=3xS3sydPYQqhJUOdPd1l/7oX7BNSxPzm2+svICNYRn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z324Ovd6oTXcMQ5Sh9NF2ineL5NOb09nV4CaKn+QA4llOcAzzVa4+dlY+fpv+RXtFPpa/L6YtmrEg2xAatRFSPH5AR+ijEt1Xgfpq+lgr7XNOColTKAdKlQFaKa/lOKdhssCXk0ZK4tq9CRHVAytK6BP/Nw6G1JXIIw1CWJf+tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbLHuCvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbLHuCvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D96C4CEFB;
	Sat, 25 Oct 2025 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408604;
	bh=3xS3sydPYQqhJUOdPd1l/7oX7BNSxPzm2+svICNYRn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbLHuCvw4M3uA3vSHss2hweEErrLvoD5o0Fa8cnKvazOjPw4tTzjInrCgqILeh+Ru
	 xGC3nB+d6JkEMiXygvDtP5/ted4xQDjZHRXVu9RQIUjy8O7vYMGzm1NJCqVnQbC/4J
	 dfgH12omWhesLQlZb66g7HUby4Q5UjCHgGukj/zq7T6Q7zC9X7tNC09KtS+UFLFFV8
	 /Xwx99601KY5MS17Olfx+hDS4odpQimDI/FdUP422KidimzKH72SKNI2dgIZpiMocG
	 3LNjUAvc0i7gUNLSIluWPVda7IRtyPhvUUUerxNJXb3kernYKcV6smXB6ZpbIRUInq
	 CGB/9BTTc+yzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomer Tayar <tomer.tayar@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	peterz@infradead.org,
	gregkh@linuxfoundation.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 6.17-6.6] accel/habanalabs: return ENOMEM if less than requested pages were pinned
Date: Sat, 25 Oct 2025 11:54:10 -0400
Message-ID: <20251025160905.3857885-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomer Tayar <tomer.tayar@intel.com>

[ Upstream commit 9f5067531c9b79318c4e48a933cb2694f53f3de2 ]

EFAULT is currently returned if less than requested user pages are
pinned. This value means a "bad address" which might be confusing to
the user, as the address of the given user memory is not necessarily
"bad".

Modify the return value to ENOMEM, as "out of memory" is more suitable
in this case.

Signed-off-by: Tomer Tayar <tomer.tayar@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change only adjusts the fallback errno when
  `pin_user_pages_fast()` pins fewer pages than requested, switching
  from `-EFAULT` to `-ENOMEM` in `get_user_memory()`
  (`drivers/accel/habanalabs/common/memory.c:2333`,
  `drivers/accel/habanalabs/common/memory.c:2340`). That path feeds
  directly into the user-visible `hl_pin_host_memory()` ioctl stack, so
  the errno returned to userspace shifts with no other behavioral
  differences.
- A shortfall from `pin_user_pages_fast()` is typically triggered by
  resource exhaustion (memlock limits, long-term pinning restrictions,
  or temporary faults) rather than an invalid pointer. GUP’s core
  comment and return path (`mm/gup.c:1324`, `mm/gup.c:1509`) document
  that it returns the number of pages successfully pinned even when the
  underlying failure was `-ENOMEM`/`-EAGAIN`/`-EFAULT`, so callers lose
  the real error code once any pages were pinned. Treating the condition
  as out-of-resources better matches the dominant failure mode and
  mirrors what other subsystems do (e.g. the VDUSE bounce buffer path
  uses the same fallback to `-ENOMEM`,
  `drivers/vdpa/vdpa_user/vduse_dev.c:1116`).
- Leaving it as `-EFAULT` misdirects userspace into believing the
  address is invalid, which can mask real memory-pressure problems and
  complicate recovery. The driver already logs a detailed error, so the
  only user-visible change is a more accurate errno for a genuine
  failure case.
- Regression risk is negligible: no control flow moved, and no in-kernel
  caller special-cases the old errno. The edit is self-contained and
  stable-friendly; older trees only need the path adjusted back to
  `drivers/misc/habanalabs/common/memory.c`.
- Recommended next steps: if you pull this into stable, queue a quick
  smoke test of the habanalabs memory-pinning ioctl to confirm expected
  errno propagation under memlock exhaustion.

 drivers/accel/habanalabs/common/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 61472a381904e..48d2d598a3876 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -2332,7 +2332,7 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 		if (rc < 0)
 			goto destroy_pages;
 		npages = rc;
-		rc = -EFAULT;
+		rc = -ENOMEM;
 		goto put_pages;
 	}
 	userptr->npages = npages;
-- 
2.51.0

