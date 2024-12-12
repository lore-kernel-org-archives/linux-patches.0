Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B1229698;
	Thu, 12 Dec 2024 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020096; cv=none; b=i09knnHqZJqWyI3g77q+ah//1Xg6Xg+r5cQ5qEPCFea2qJo6dom1P5iTzfO/CQxucphD0wKqYzCunutXkziGBbNb+s8a382aIo2EcqC0Ht5xDyUq0uaF88ONEX0/dTdu0yaqLPW9KGPZ0CMqDDJh98ecNldYTf4RsvG/5G2aYTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020096; c=relaxed/simple;
	bh=r+eZd26v3z0d/Bfpn3qfNsl9WcJotGHK1TfSJgI9Adw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3UO8AIEMjtOP1nVVqjIYA03IGDGOPBcrBSYFTtdjBdjY9OpGA6kbOfHQ/l4PzMWi1D/amxotpVSo62Yf5/NlbIXrogoEwIq2hk0sjLWPDs4DFOkFCKtcHAZfWqlgGY032XNxG4JqWUS9z0CmgbO873lXa5gkhytGrAer2WzMP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BImCNXat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BImCNXat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC5FC4CECE;
	Thu, 12 Dec 2024 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020095;
	bh=r+eZd26v3z0d/Bfpn3qfNsl9WcJotGHK1TfSJgI9Adw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BImCNXatHaCv1CpYmizVoNgE70dQSpVzYzbfGfuItpCNaF0fHndEl/54m4z6jh1nF
	 LpSRb7rcPqccPtsoFDBavpEdHjAnlBRwxlxfa5TvTzoXxiQ5OStH8Y95T2vW4cADt3
	 3rsLvlWz6E0bnaw5EysOfRmuW5DmjkdX5whXazfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.1 376/772] apparmor: test: Fix memory leak for aa_unpack_strdup()
Date: Thu, 12 Dec 2024 15:55:21 +0100
Message-ID: <20241212144405.440700738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 7290f59231910ccba427d441a6e8b8c6f6112448 upstream.

The string allocated by kmemdup() in aa_unpack_strdup() is not
freed and cause following memory leaks, free them to fix it.

	unreferenced object 0xffffff80c6af8a50 (size 8):
	  comm "kunit_try_catch", pid 225, jiffies 4294894407
	  hex dump (first 8 bytes):
	    74 65 73 74 69 6e 67 00                          testing.
	  backtrace (crc 5eab668b):
	    [<0000000001e3714d>] kmemleak_alloc+0x34/0x40
	    [<000000006e6c7776>] __kmalloc_node_track_caller_noprof+0x300/0x3e0
	    [<000000006870467c>] kmemdup_noprof+0x34/0x60
	    [<000000001176bb03>] aa_unpack_strdup+0xd0/0x18c
	    [<000000008ecde918>] policy_unpack_test_unpack_strdup_with_null_name+0xf8/0x3ec
	    [<0000000032ef8f77>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000f3edea23>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000adf936cf>] kthread+0x2e8/0x374
	    [<0000000041bb1628>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80c2a29090 (size 8):
	  comm "kunit_try_catch", pid 227, jiffies 4294894409
	  hex dump (first 8 bytes):
	    74 65 73 74 69 6e 67 00                          testing.
	  backtrace (crc 5eab668b):
	    [<0000000001e3714d>] kmemleak_alloc+0x34/0x40
	    [<000000006e6c7776>] __kmalloc_node_track_caller_noprof+0x300/0x3e0
	    [<000000006870467c>] kmemdup_noprof+0x34/0x60
	    [<000000001176bb03>] aa_unpack_strdup+0xd0/0x18c
	    [<0000000046a45c1a>] policy_unpack_test_unpack_strdup_with_name+0xd0/0x3c4
	    [<0000000032ef8f77>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000f3edea23>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000adf936cf>] kthread+0x2e8/0x374
	    [<0000000041bb1628>] ret_from_fork+0x10/0x20

Cc: stable@vger.kernel.org
Fixes: 4d944bcd4e73 ("apparmor: add AppArmor KUnit tests for policy unpack")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack_test.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/security/apparmor/policy_unpack_test.c
+++ b/security/apparmor/policy_unpack_test.c
@@ -286,6 +286,8 @@ static void policy_unpack_test_unpack_st
 			   ((uintptr_t)puf->e->start <= (uintptr_t)string)
 			   && ((uintptr_t)string <= (uintptr_t)puf->e->end));
 	KUNIT_EXPECT_STREQ(test, string, TEST_STRING_DATA);
+
+	kfree(string);
 }
 
 static void policy_unpack_test_unpack_strdup_with_name(struct kunit *test)
@@ -301,6 +303,8 @@ static void policy_unpack_test_unpack_st
 			   ((uintptr_t)puf->e->start <= (uintptr_t)string)
 			   && ((uintptr_t)string <= (uintptr_t)puf->e->end));
 	KUNIT_EXPECT_STREQ(test, string, TEST_STRING_DATA);
+
+	kfree(string);
 }
 
 static void policy_unpack_test_unpack_strdup_out_of_bounds(struct kunit *test)
@@ -318,6 +322,8 @@ static void policy_unpack_test_unpack_st
 	KUNIT_EXPECT_EQ(test, size, 0);
 	KUNIT_EXPECT_NULL(test, string);
 	KUNIT_EXPECT_PTR_EQ(test, puf->e->pos, start);
+
+	kfree(string);
 }
 
 static void policy_unpack_test_unpack_nameX_with_null_name(struct kunit *test)


