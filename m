Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB517C;
	Sun,  1 Sep 2024 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210256; cv=none; b=IvOvWg3cJsyrcsXKWcFXi9CE4nFN6rFpZrHrF8xAL3LsnAD7OjqlKuLmFKop8e+ELNF9l9A0a8DkjOoErX3Ygfk0uaQo+Zd6ngvkKCE8SUVKrN2VuibdHyh77YIS2mUw0mZwlUI/ptaA5LY3yOAE+c9RaiUoV9LBMHdXPWLslnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210256; c=relaxed/simple;
	bh=6jsrBsZ5WcCO18I5+RpRr/HdWb7Tue0JHXFHqeM4X+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozfWLzprsUcluIFy+6GE9gSHc0Pj7OYlS/50KYTC9dFTs4alAf1ATIwLYbXOi3DsD169hAB2UMhfrFnqfiIZssP29KFyPAc9E6NJNgvli+3mSUXxtbwIcOpQB5DZRLIlLuD68wSOnEbdgp1Al83y8E9gspnAnPY0jdK51taIdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D29ekDlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D29ekDlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459B1C4CEC3;
	Sun,  1 Sep 2024 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210256;
	bh=6jsrBsZ5WcCO18I5+RpRr/HdWb7Tue0JHXFHqeM4X+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D29ekDlbJrfuC/KdiCYXGRvsYjHXilBMtukAlwux+RUQokXhWcbb0Bo0lzz81Tld7
	 b/TsKsMg+VTelLhuHr18F7A6PgRb3gvYUZRajHtKd5QwPpVfygp7R3BvklwskMWmlr
	 d0xGaEbdUHDIKNid+jWSv9Psg7nWkyKowZipBRu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/215] tc-testing: dont access non-existent variable on exception
Date: Sun,  1 Sep 2024 18:17:26 +0200
Message-ID: <20240901160828.432084117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit a0c9fe5eecc97680323ee83780ea3eaf440ba1b7 ]

Since commit 255c1c7279ab ("tc-testing: Allow test cases to be skipped")
the variable test_ordinal doesn't exist in call_pre_case().
So it should not be accessed when an exception occurs.

This resolves the following splat:

  ...
  During handling of the above exception, another exception occurred:

  Traceback (most recent call last):
    File ".../tdc.py", line 1028, in <module>
      main()
    File ".../tdc.py", line 1022, in main
      set_operation_mode(pm, parser, args, remaining)
    File ".../tdc.py", line 966, in set_operation_mode
      catresults = test_runner_serial(pm, args, alltests)
    File ".../tdc.py", line 642, in test_runner_serial
      (index, tsr) = test_runner(pm, args, alltests)
    File ".../tdc.py", line 536, in test_runner
      res = run_one_test(pm, args, index, tidx)
    File ".../tdc.py", line 419, in run_one_test
      pm.call_pre_case(tidx)
    File ".../tdc.py", line 146, in call_pre_case
      print('test_ordinal is {}'.format(test_ordinal))
  NameError: name 'test_ordinal' is not defined

Fixes: 255c1c7279ab ("tc-testing: Allow test cases to be skipped")
Signed-off-by: Simon Horman <horms@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20240815-tdc-test-ordinal-v1-1-0255c122a427@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tdc.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index a3e43189d9400..d6a9d97f73c24 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -129,7 +129,6 @@ class PluginMgr:
             except Exception as ee:
                 print('exception {} in call to pre_case for {} plugin'.
                       format(ee, pgn_inst.__class__))
-                print('test_ordinal is {}'.format(test_ordinal))
                 print('testid is {}'.format(caseinfo['id']))
                 raise
 
-- 
2.43.0



