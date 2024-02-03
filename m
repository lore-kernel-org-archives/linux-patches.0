Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF102C68F;
	Sat,  3 Feb 2024 04:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933977; cv=none; b=tjv4JijmCtPLYQefrgL4pmZ3AOXRzBOxFqoXlfeJ75hML4msKyEnQU3z0lsQj2yMaCaM5PqAf8PWn4Em7G82SOQ8ZN13tYy+h+VLt4HZ7X2Ctpt+Z4qKRnCHoHfUX6LmB1VkIe046NTQyr9v4RirWtEhxdA060Q/Z7YqHl3iSyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933977; c=relaxed/simple;
	bh=+j+lGfTUt0hv/myR6pJvlX0MZuvtrUeZDl0Aox59hwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LngdV7Di8Jr+4pih2p/ixf4hXGZYwv6ZTaNHw0elZ0831hVQgZf5bnTGBCjTSI4PhKUPGmmI7TfNUTD+aYOGv847AYI4C1F8Kdc2ftzTwwoOzJA7x/l8v66nW9nc+9tFPq1lpyFQcZXaYta94C7Z2qYDQ5GTlsdXLv/v11C4/XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Yi0Go3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Yi0Go3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98784C43399;
	Sat,  3 Feb 2024 04:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933977;
	bh=+j+lGfTUt0hv/myR6pJvlX0MZuvtrUeZDl0Aox59hwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Yi0Go3zi53z8D2vmTKkZJNBF/mkPDY1bZBWKI+4sgtETdpIpNXKrbySl5LCkkh3Q
	 Z9d38cDV4L7QT9c+h0y3WJE2sGZg6lSLPW3fIrJKuw+GHfGd8VVTtcIudB2punZKpW
	 K26J/B48mkLP5owrwN2FfFjEGliqc5dG73uyZuy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: [PATCH 6.7 352/353] selftests/bpf: Remove flaky test_btf_id test
Date: Fri,  2 Feb 2024 20:07:50 -0800
Message-ID: <20240203035414.879666595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

commit 56925f389e152dcb8d093435d43b78a310539c23 upstream.

With previous patch, one of subtests in test_btf_id becomes
flaky and may fail. The following is a failing example:

  Error: #26 btf
  Error: #26/174 btf/BTF ID
    Error: #26/174 btf/BTF ID
    btf_raw_create:PASS:check 0 nsec
    btf_raw_create:PASS:check 0 nsec
    test_btf_id:PASS:check 0 nsec
    ...
    test_btf_id:PASS:check 0 nsec
    test_btf_id:FAIL:check BTF lingersdo_test_get_info:FAIL:check failed: -1

The test tries to prove a btf_id not available after the map is closed.
But btf_id is freed only after workqueue and a rcu grace period, compared
to previous case just after a rcu grade period.
Depending on system workload, workqueue could take quite some time
to execute function bpf_map_free_deferred() which may cause the test failure.
Instead of adding arbitrary delays, let us remove the logic to
check btf_id availability after map is closed.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20231214203820.1469402-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4630,11 +4630,6 @@ static int test_btf_id(unsigned int test
 	/* The map holds the last ref to BTF and its btf_id */
 	close(map_fd);
 	map_fd = -1;
-	btf_fd[0] = bpf_btf_get_fd_by_id(map_info.btf_id);
-	if (CHECK(btf_fd[0] >= 0, "BTF lingers")) {
-		err = -1;
-		goto done;
-	}
 
 	fprintf(stderr, "OK");
 


