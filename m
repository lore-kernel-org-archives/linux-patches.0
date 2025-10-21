Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03385350A0D;
	Tue, 21 Oct 2025 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077383; cv=none; b=TewNYNRMD4vfREyMUTxLzNW8V1zV8RLuuyuNP/sXDoxwgWUrpnov5sh6E5NATqbHPWg5MAhL4Up3cMkTQt+GN5yv9qoP3zqgBuWiXXukeFQvE1mUG0yRbs6HeJTBW0BP8zsgcy5MKuq3G8Ip9KmsJX6ytWV8IcYYLyzwzfSGe8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077383; c=relaxed/simple;
	bh=J2JKEnoyz51nYnKncfDrQMiTjvsEA/3L4gcvfnDjpvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoKqH+bfXiYzteIEwNa5/tJDO9hLnfIRegkC31pDBm+a3PrLLe3M6XrK0vjGzB7Ux/Q8px6LEQ1HIFwptEI2yP1hnZs/md4h8ie3+uTWVhhDfcGm5GahSulr/fZB+0rnlu0y/E9Ug/ee7hdPztdxTrW7cE+eSQfnJpc0Sf5T7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDdqtRja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDdqtRja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A90AC4CEF1;
	Tue, 21 Oct 2025 20:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077382;
	bh=J2JKEnoyz51nYnKncfDrQMiTjvsEA/3L4gcvfnDjpvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDdqtRjagBNxUVhkRJ7IEzgYE6geHkMSeCT3CfVP7aOjc2eihOvAVNDg/fZCgD0wj
	 qqKStf2eDaeY3OhVZsHiDBr5Vr0Xgu2cUvvmnbMSYIoolk6YwzEUaD7zo8hYOrvLC2
	 kDA803/G/HNy43+ODOIUHMwNKlZX9ILDhnp0HwqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.17 045/159] perf/core: Fix MMAP event path names with backing files
Date: Tue, 21 Oct 2025 21:50:22 +0200
Message-ID: <20251021195044.288987907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 8818f507a9391019a3ec7c57b1a32e4b386e48a5 upstream.

Some file systems like FUSE-based ones or overlayfs may record the backing
file in struct vm_area_struct vm_file, instead of the user file that the
user mmapped.

Since commit def3ae83da02f ("fs: store real path instead of fake path in
backing file f_path"), file_path() no longer returns the user file path
when applied to a backing file.  There is an existing helper
file_user_path() for that situation.

Use file_user_path() instead of file_path() to get the path for MMAP
and MMAP2 events.

Example:

  Setup:

    # cd /root
    # mkdir test ; cd test ; mkdir lower upper work merged
    # cp `which cat` lower
    # mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
    # perf record -e intel_pt//u -- /root/test/merged/cat /proc/self/maps
    ...
    55b0ba399000-55b0ba434000 r-xp 00018000 00:1a 3419                       /root/test/merged/cat
    ...
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.060 MB perf.data ]
    #

  Before:

    File name is wrong (/cat), so decoding fails:

    # perf script --no-itrace --show-mmap-events
             cat     367 [016]   100.491492: PERF_RECORD_MMAP2 367/367: [0x55b0ba399000(0x9b000) @ 0x18000 00:02 3419 489959280]: r-xp /cat
    ...
    # perf script --itrace=e | wc -l
    Warning:
    19 instruction trace errors
    19
    #

  After:

    File name is correct (/root/test/merged/cat), so decoding is ok:

    # perf script --no-itrace --show-mmap-events
                 cat     364 [016]    72.153006: PERF_RECORD_MMAP2 364/364: [0x55ce4003d000(0x9b000) @ 0x18000 00:02 3419 3132534314]: r-xp /root/test/merged/cat
    # perf script --itrace=e
    # perf script --itrace=e | wc -l
    0
    #

Fixes: def3ae83da02f ("fs: store real path instead of fake path in backing file f_path")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9403,7 +9403,7 @@ static void perf_event_mmap_event(struct
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
-		name = file_path(file, buf, PATH_MAX - sizeof(u64));
+		name = d_path(file_user_path(file), buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
 			name = "//toolong";
 			goto cpy_name;


